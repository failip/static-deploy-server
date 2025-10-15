# Static Deploy Server

A lightweight Nginx-based server for hosting static websites with support for
precompressed files (Brotli, Zstd, and Gzip). This setup allows you to build and
precompress your site in CI/CD pipelines like GitHub Actions, then upload the
compressed files directly to the server without needing to build on the hosting
machine.

## Features

- Serves static files with automatic compression support.
- Upload endpoint for deploying new builds via tar archives.
- Secure uploads using a secret token.
- Runs in a Docker container for easy deployment.

## Usage

### Building the Docker Image

```bash
docker build -t static-deploy .
```

### Running the Container

Set the `UPLOAD_SECRET` environment variable to a secure token for upload
authentication:

```bash
docker run -p 80:80 -e UPLOAD_SECRET=your_secret_token static-deploy
```

The server will listen on port 80.

### Uploading Files

To deploy your site, create a tar archive of your precompressed static files and
upload it via POST to `/upload` with the header `X-Upload-Token` set to your
secret:

```bash
curl -X POST -H "X-Upload-Token: your_secret_token" --data-binary @site.tar http://your-server/upload
```

The upload handler will:

- Extract the tar to `/var/www/uploads`.
- Remove old files (except the temporary tar).
- Serve the new files from the root location.

### Example GitHub Actions Workflow

In your `.github/workflows/deploy.yml`:

```yaml
name: Deploy
on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and compress
        run: |
          # Your build steps here
          # Precompress files (e.g., using brotli, zstd, gzip)
      - name: Upload
        run: |
          tar -cf site.tar .
          curl -X POST -H "X-Upload-Token: ${{ secrets.UPLOAD_SECRET }}" --data-binary @site.tar http://your-server/upload
```

## Requirements

- Docker
- A secret token for uploads (set as `UPLOAD_SECRET`)

## Notes

- Files are served from `/var/www/uploads`.
- Supports Brotli, Zstd, and Gzip static compression.
- Uploads are limited to 2GB by default.
