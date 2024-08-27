<p align="center">
  <img height="100" src="./app/assets/images/mockr.svg" alt="Mockr" />
</p>

<p align="center">
  <img height="20" src="https://app.codacy.com/project/badge/Grade/db335904b8cf4fc9ac115159e351b963" alt="Codacy Code Quality" />
  <img height="20" src="https://app.codacy.com/project/badge/Coverage/db335904b8cf4fc9ac115159e351b963" alt="Codacy Code Coverage" />
</center>

---

A simple, yet customizable API mock server built with Ruby on Rails. With Mockr you can easily create mock endpoints for your API, and customize the response data to fit your needs. Responses are built in a way where they're stored encrypted on your own `S3` instance. Authentication is done through GitHub, and you can easily configure which GitHub organization is allowed to access your Mockr instance. The `Manager` and `User` roles define who can create and edit endpoints, and who can only view them respectively.

---

## Dependencies

- Ruby: 3.3.4
- Node: 18.20.1
- Postgres: 15

## Building for Production

Make sure your environment variables are set up correctly. You can find a list of all the required environment variables in `.env.example`. Current supported oAuth providers are **GitHub** and **Okta**. For GitHub, if you don't set `GITHUB_ORGANIZATION`, anyone with a GitHub account will be able to login. A simple build script is included on `./bin/builds/rails.sh`.

## Development Setup

- Clone this repository somewhere of your preference
- Copy `.env.example` to `.env` and fill it in
- Run `bundle install`
- Run `RAILS_ENV=development bundle exec rails db:create db:migrate`
- Run `RAILS_ENV=test bundle exec rails db:create db:migrate`
- Start the rails server with `bundle exec rails server`

For JavaScript and CSS development, you'll need to install the dependencies with `yarn install`. Use `yarn watch` to watch for changes on the JavaScript files and `yarn watch:css` to watch for changes on the CSS files. Use `yarn build` and `yarn build:css` to build them instead.

## Running Tests

- Run `RAILS_ENV=test bundle exec rspec`
- Or `RAILS_ENV=test bundle exec rspec [relative_file_path]`
- Or `RAILS_ENV=test bundle exec rspec [relative_file_path]:[line]`

## Checking Rubocop Offenses

- Run `bundle exec rubocop`

---

## Versioning

Mockr uses [SemVer](https://semver.org/) for versioning. For the versions available, check the releases on this repository. Versions before `v1.0.0` are considered unstable and may contain breaking changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
