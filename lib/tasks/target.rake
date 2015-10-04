require 'csv'

namespace :target do
  desc "Import from CSV"
  task import: :environment do
    counter = 0

    CSV.foreach("/Users/croaky/dev/thoughtbot/hound/targets.csv") do |row|
      counter += 1
      next if counter == 1

      create_records(row[0], "RuboCop")
      create_records(row[1], "CoffeeLint")
      create_records(row[2], "JSHint")
      create_records(row[3], "SCSS Lint")
      create_records(row[4], "Haml-Lint")
      create_records(row[5], "Flake8 (Python)")
      create_records(row[6], "Golint")
    end
  end

  def create_records(repo_name, linter_name)
    if repo_name.present?
      target = OssTarget.find_or_create_by(name: repo_name)

      if target.persisted?
        target.oss_target_linters.create(name: linter_name)
      end
    end
  end

  desc "Clean out repos already active or with low follower counts"
  task clean: :environment do
    OssTarget.find_each do |target|
      if Repo.find_by(full_github_name: target.name, active: true)
        target.destroy
      elsif target.fetched_github == true && target.followers_count < 500
        target.destroy
      end
    end
  end

  desc "Get follower counts"
  task get_follower_counts: :environment do
    api = GithubApi.new(Hound::GITHUB_TOKEN)

    OssTarget.where("fetched_github = false").order(:name).limit(600).each do |target|
      puts target.name

      begin
        repo = api.repo(target.name)
        target.followers_count = repo[:watchers_count] || 0
        target.language = repo[:language]
        target.fetched_github = true
        target.save
      rescue Octokit::NotFound
        target.destroy
      end
    end
  end

  desc "Export CSV"
  task export_csv: :environment do
    CSV.open("/Users/croaky/dev/thoughtbot/hound/cleaned.csv", "wb") do |csv|
      csv << [
        "Repo Name",
        "Followers",
        "Language",
        "Linters",
        "PR URL"
      ]

      OssTarget.order("followers_count DESC").all.each do |target|
        csv << [
          "https://github.com/#{target.name}",
          target.followers_count,
          target.language,
          target.oss_target_linters.order(:name).map(&:name).join(",")
        ]
      end
    end
  end
end
