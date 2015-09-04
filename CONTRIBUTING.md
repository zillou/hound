# Contributing

First, thank you for contributing!

We love pull requests from everyone. By participating in this project, you
agree to abide by the thoughtbot [code of conduct].

[code of conduct]: https://thoughtbot.com/open-source-code-of-conduct

Here are a few technical guidelines to follow:

1. Open an [issue][issues] to discuss a new feature.
1. Write tests.
1. Make sure the entire test suite passes locally and on Travis CI.
1. Open a Pull Request.
1. [Squash your commits][squash] after receiving feedback.
1. Party!

[issues]: https://github.com/thoughtbot/hound/issues
[squash]: https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature

## Configure Hound on Your Local Development Environment

1. After cloning the repository, run the setup script

    `./bin/setup`

    **NOTE:** If you don't need Hound to communicate with your local machine, you may skip steps 2-5.
    Designers, you don't need localtunnel for the purpose of making css changes and running the app locally.

1. We need to expose the local app via a publicly-accessible, stable URL so that GitHub can send webhook requests to start a build. Install localtunnel:

    `npm install -g localtunnel

1. Tell localtunnel to expose localhost:5000 with a custom subdomain:

    `localtunnel --port 5000 --subdomain <your-initials>hound`

1. Set the `HOST` variable in your `.env.local` to your localtunnel host, e.g.
   `https://<your-initials>hound.localtunnel.me`.

1. Add `ENABLE_HTTPS=yes` to the `.env.local` file.

1. [Register a new GitHub application][new-application]:

    * Application Name: Hound Development
    * Homepage URL: `https://<your-initials>hound.localtunnel.me`
      **NOTE:** If you did not set up localtunnel, use `http://localhost:5000`
    * Authorization Callback URL: `https://<your-initials>hound.localtunnel.me`
      **NOTE:** If you did not set up localtunnel, use `http://localhost:5000`

1. If you did not set up localtunnel, skip to the last step now.

1. On the confirmation screen, copy the `Client ID` as `GITHUB_CLIENT_ID` and
   the `Client Secret` as `GITHUB_CLIENT_SECRET` in the `.env.local` file.

1. Back on the [application settings] page, click "Generate new token" and fill
   in token details:

    * Token description: Hound Development
    * Select scopes: `repo` and `user:email`

1. On the confirmation screen, copy the generated token to `HOUND_GITHUB_TOKEN`
   in the `.env.local` file. Also update `HOUND_GITHUB_USERNAME` to be your username.

1. Run `foreman start` (not `rails server`). Foreman will start the web server and
   the resque background job queue.

[new-application]: https://github.com/settings/applications/new
[application settings]: https://github.com/settings/applications

## Testing

1. Set up your `development` environment as per above.
1. Run `rake` to execute the full test suite.

To test Stripe payments on staging use this fake credit card number.

<table>
  <thead>
    <tr>
      <th>Card</th>
      <th>Number</th>
      <th>Expiration</th>
      <th>CVV</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Visa</td>
      <td>4242424242424242</td>
      <td>Any future date</td>
      <td>Any 3 digits</td>
    </tr>
  </tbody>
</table>

## Contributor License Agreement

If you submit a Contribution to this application's source code, you hereby grant
to thoughtbot, inc. a worldwide, royalty-free, exclusive, perpetual and
irrevocable license, with the right to grant or transfer an unlimited number of
non-exclusive licenses or sublicenses to third parties, under the Copyright
covering the Contribution to use the Contribution by all means, including but
not limited to:

* to publish the Contribution,
* to modify the Contribution, to prepare Derivative Works based upon or
  containing the Contribution and to combine the Contribution with other
  software code,
* to reproduce the Contribution in original or modified form,
* to distribute, to make the Contribution available to the public, display and
  publicly perform the Contribution in original or modified form.
