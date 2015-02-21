class RubyViolationAnalytics
  def initialize(repos)
    @repos = repos
  end

  def violation_counts
    violation_counts = messages
      .group_by { |message| message }
      .map do |message, matching_messages|
        [message, matching_messages.count]
      end

    violation_counts.sort_by { |a, b| b }.reverse.take(20)
  end

  # private

  def messages
    @messages ||= @repos.flat_map do |repo|
      build_ids = repo.build_ids
      violations = Violation.where(build_id: build_ids)
      violations.flat_map { |violation| violation.messages }
    end
  end

  def all_rules
    RuboCop::Cop::Cop.all.map do |cop|
      begin
        cop::MSG
      rescue NameError
      end
    end.compact.uniq
  end

  def rules
    [
      "Ambiguous regexp literal. Parenthesize the method arguments if it's surely a regexp literal, or add a whitespace to the right of the `/` if it should be a division.",
      "Assignment in condition - you probably meant to use `==`.",
      "`end` at %d, %d is not aligned with `%s` at %d, %d%s",
      "Remove debugger entry point `%s`.",
      "`end` at %d, %d is not aligned with `%s` at %d, %d",
      "`%s` is deprecated in favor of `%s`.",
      "Duplicate methods `%s` at lines `%s` detected.",
      "Empty `ensure` block detected.",
      "Empty interpolation detected.",
      "`END` found in method definition. Use `at_exit` instead.",
      "Do not return from an `ensure` block.",
      "The use of `eval` is a serious security risk.",
      "Do not suppress exceptions.",
      "Literal `%s` appeared in a condition.",
      "Literal interpolation detected.",
      "Use `Kernel#loop` with `break` rather than `begin/end/until`(or `while`).",
      "`(...)` interpreted as grouped expression.",
      "Use parentheses in the method call to avoid confusion about precedence.",
      "Avoid rescuing the `Exception` class. Perhaps you meant to rescue `StandardError`?",
      "Shadowing outer local variable - `%s`.",
      "Put space between the method name and the first argument.",
      "Do not use prefix `_` for a variable that is used.",
      "Unreachable code detected.",
      "Useless `%s` access modifier.",
      "Useless assignment to variable - `%s`.",
      "Comparison of something with itself detected.",
      "`else` without `rescue` is useless.",
      "Useless setter call to local variable `%s`.",
      "Cyclomatic complexity for %s is too high. [%d/%d]",
      "Assignment Branch Condition size for %s is too high. [%.4g/%.4g]",
      "Line is too long. [%d/%d]",
      "Avoid parameter lists longer than %d parameters.",
      "Perceived complexity for %s is too high. [%d/%d]",
      "%s access modifiers like `%s`.",
      "Use `alias_method` instead of `alias`.",
      "Align the elements of an array literal if they span more than one line.",
      "Align the elements of a hash literal if they span more than one line.",
      "Align the parameters of a method call if they span more than one line.",
      "Use `%s` instead of `%s`.",
      "Favor `Array#join` over `Array#*`.",
      "Use only ascii symbols in comments.",
      "Use only ascii symbols in identifiers.",
      "Do not use `attr`. Use `attr_reader` instead.",
      "Use `%%%s` instead of `%%%s`.",
      "Avoid the use of `BEGIN` blocks.",
      "Do not use block comments.",
      "Expression at %d, %d should be on its own line.",
      "%s curly braces around a hash parameter.",
      "Avoid the use of the case equality operator `===`.",
      "Do not use the character literal - use string literal instead.",
      "Use CamelCase for classes and modules.",
      "Prefer `Object#%s` over `Object#%s`.",
      "Use `self.%s` instead of `%s.%s`.",
      "Replace class var %s with a class instance var.",
      "Prefer `%s` over `%s`.",
      "Do not use `::` for method calls.",
      "Annotation keywords should be all upper case, followed by a colon and a space, then a note describing the problem.",
      "Incorrect indentation detected (column %d instead of %d).",
      "Use SCREAMING_SNAKE_CASE for constants.",
      "Omit the parentheses in defs when the method doesn't accept any arguments.",
      "`Hash#%s` is deprecated in favor of `Hash#%s`.",
      "Missing top-level %s documentation comment.",
      "Avoid the use of double negation (`!!`).",
      "Use `each_with_object` instead of `%s`.",
      "Align `%s` with `%s`.",
      "Redundant empty `else`-clause.",
      "Use empty lines between defs.",
      "Extra blank line detected.",
      "Keep a blank line before and after `%s`.",
      "Avoid the use of `END` blocks. Use `Kernel#at_exit` instead.",
      "Carriage return character detected.",
      "Replace with `Fixnum#%s?`.",
      "Unnecessary spacing detected.",
      "Use snake_case for source file names.",
      "Avoid the use of flip flop operators.",
      "Do not introduce global variables.",
      "Use a guard clause instead of wrapping the code inside a conditional expression.",
      "Do not use if x; Use the ternary operator instead.",
      "Inconsistent indentation detected.",
      "Use `Kernel#loop` for infinite loops.",
      "Avoid inline comments.",
      "Missing space after #.",
      "Use `\\` instead of `+` or `<<` to concatenate those strings.",
      "Do not use parentheses for method calls with no arguments.",
      "Avoid chaining a method call on a do...end block.",
      "Use `module_function` instead of `extend self`.",
      "Avoid multi-line chains of blocks.",
      "Block body expression is on the same line as the block start.",
      "Avoid multi-line ?: (the ternary operator); use `if`/`unless` instead.",
      "Favor `%s` over `%s` for negative conditions.",
      "Ternary operators must not be nested. Prefer `if`/`else` constructs instead.",
      "Use `next` to skip iteration.",
      "Prefer the use of the `nil?` predicate.",
      "Use `!` instead of `not`.",
      "Separate every 3 digits in the integer portion of a number with underscores(_).",
      "Favor the ternary operator (?:) over if/then/else/end constructs.",
      "When defining the `%s` operator, name its argument `other`.",
      "Avoid the use of Perl-style backrefs.",
      "Use `proc` instead of `Proc.new`.",
      "Redundant `begin` block detected.",
      "Redundant `RuntimeError` argument can be removed.",
      "Redundant `return` detected.",
      "Redundant `self` detected.",
      "Avoid using `rescue` in its modifier form.",
      "Use self-assignment shorthand `%s=`.",
      "Do not use semicolons to terminate expressions.",
      "Avoid single-line method definitions.",
      "Put one space between the method name and the first argument.",
      "Space missing after colon.",
      "Space missing after %s.",
      "Use space after control keywords.",
      "Do not put a space between a method name and the opening parenthesis.",
      "Do not leave space between `!` and its argument.",
      "Space found before %s.",
      "Put a space before an end-of-line comment.",
      "Put a space before the modifier keyword.",
      "Space inside %s detected.",
      "Space inside %s.",
      "Space inside range literal.",
      "Don't extend an instance initialized by `Struct.new`.",
      "Use %i or %I for array of symbols.",
      "Pass `&:%s` as an argument to `%s` instead of a block.",
      "Tab detected.",
      "%s comma after the last %s",
      "Trailing whitespace detected.",
      "Use `attr_%s` to define trivial %s methods.",
      "Do not use `unless` with `else`. Rewrite these with the positive case first.",
      "Do not use `%W` unless interpolation is needed.  If not, use `%w`.",
      "Use `%s` only for strings that contain both single quotes and double quotes%s.",
      "Do not use `%x` unless the command string contains backquotes.",
      "Replace interpolated variable `%s` with expression `\#{%s}`.",
      "Do not use `when x;`. Use `when x then` instead.",
        "Use `%w` or `%W` for array of words.",
        "`default_scope` expects a block as its sole argument.",
        "Use `delegate` to define delegations.",
        "Prefer `has_many :through` to `has_and_belongs_to_many`.",
        "Do not write to stdout. Use Rails' logger if you want to log.",
        "Use `lambda`/`proc` instead of a plain method call.",
        "Prefer the new style validations `%s` over `%s`."]
  end
end
