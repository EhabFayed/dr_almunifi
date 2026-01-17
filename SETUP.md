# dr_elmunify Setup Instructions

This directory contains the initial configuration to bootstrap the `dr_elmunify` Rails project using Docker.

## 1. Move to Correct Location

Since these files were generated inside `webops_task`, you first need to move them to the parent `milaknight` directory:

```bash
mv dr_elmunify ../
cd ../dr_elmunify
```

## 2. Bootstrap the Application

Run the following commands to generate the Rails application structure:

### Build the Docker image
```bash
docker compose build
```

### Create the Rails app skeleton
This command runs `rails new` inside the container to generate the files.
```bash
docker compose run --rm app rails new . --force --database=postgresql --skip-bundle
```
*Note: We skip bundle because we already have a Gemfile.*

## 3. Configure Database

Rails will generate a `config/database.yml`. You need to edit it to point to the Docker database service.

**Edit `config/database.yml`**:
Ensure the `default` section matches this:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: postgres
  password: password
  host: db
```

## 4. Install Dependencies & Setup DB

```bash
docker compose run --rm app bundle install
docker compose run --rm app rails db:create
```

## 5. Start the Server

```bash
docker compose up
```

The app should now be running at `http://localhost:3000`.
