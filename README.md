# OmniFocus Extrabrain

Plugin for omnifocus gem to provide Extrabrain synchronization.

Pulls all open tasks that is assigned to you and creates corresponding actions to
your omnifocus.

If a task is markt as done in Extrabrain it will be considered and marked as
done in omnifocus. Also if a task is assigned to another person it will also be
considered as done (becouse your part of the task is probably done).

## Authenticate

To use extrabrain this gem must have access to your extrabrain credentials. I will not try to create my own unsafe password storage for this and write password each time is just annoying. Therefor I decided to use OS X own password manager, the Keychain! If you already signed in to Extrabrain using safari and saved your password you basically don't have to do anything.

If you have not authenticated to extrabrain using safari and stored your password I recomend you do that before using this gem. Or even better, create a pull request where you add the feature to manually enter credentials when `of sync` is runned. That would make me happy and i will give you a virtual :cookie:.

## Usage

1. `$ gem install omnifocus-extrabrain` or `$ sudo gem install omnifocus-extrabrain` depending on your ruby configuration.
2. Read authenticate section!!!
3. `$ of sync`
4. Trust keychain once or always (depending of what you feel is best) when the popup comes up.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/omnifocus-extrabrain/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Some todos, will you or me fix them first?

❒ Allows user to choose between keychain or other authentication method

❒ If no keychain for Extrabrain exists, ask user if one should be created and create one from the credentials the user gives.

