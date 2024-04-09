# PocketBase Docker

This repository offers an opinionated Docker setup tailored for deploying [PocketBase](https://pocketbase.io/), a backend server solution. It includes a Dockerfile for constructing a custom PocketBase image and a `run.sh` script to initialize the PocketBase instance with an admin user automatically.

**Note:** The automated creation of an admin user may not be suitable for all scenarios.

## Features

- **Custom PocketBase Image**: Utilizes Alpine Linux for a minimal footprint.
- **Automated Admin User Creation**: Simplifies setup by automatically creating an admin user upon the first run.
- **Support for Migrations and Hooks**: Facilitates the use of custom migrations and hooks through mounted volumes.

## Prerequisites

- Docker must be installed on your host system.

## Building the Docker Image

Execute the following command in the directory containing the Dockerfile to build the PocketBase Docker image:

```sh
docker build -t pocketbase-docker:latest .
```

## Running the Container

To launch the PocketBase container, use this command:

```sh
docker run -d -p 8080:8080 \
  -e "PBADMINUSR=youradminuser@example.com" \
  -e "PBADMINPWD=yoursecurepassword" \
  -v /srv/pb/pb_data:/pb/pb_data \
  -v /srv/pb/pb_migrations:/pb/pb_migrations \
  -v /srv/pb/pb_hooks:/pb/pb_hooks \
  --name pocketbase pocketbase-docker:latest
```

### Configuration Details

- **Ports**: Maps the container's PocketBase to port `8080`. Modify the `-p` option as needed.
- **Environment Variables** (with defaults provided in Dockerfile):
  - `PBADMINUSR`: Admin user email (default: `admin@example.com`).
  - `PBADMINPWD`: Admin user password (default: `ChangeMe123`).
- **Volumes**:
  - `/srv/pb/pb_data:/pb/pb_data`: For PocketBase data persistence.
  - `/srv/pb/pb_migrations:/pb/pb_migrations`: (Optional) For database migrations.
  - `/srv/pb/pb_hooks:/pb/pb_hooks`: (Optional) For custom hooks.

## Customization

- **Migrations and Hooks**: Place migration scripts in `/srv/pb/pb_migrations` and hooks in `/srv/pb/pb_hooks` on your host to have them automatically utilized by PocketBase.
- **Admin User**: Defaults to the values provided by `PBADMINUSR` and `PBADMINPWD` environment variables. Adjust these to set your preferred admin credentials.

## Security Considerations

This Docker setup automatically creates an admin user, which could introduce security risks. It's crucial to manage the admin user environment variables securely and avoid unnecessary exposure.
