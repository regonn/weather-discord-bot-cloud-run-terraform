# Weather discord bot for gcp cloud run with terraform

## Push to Container Registry

```
$ cd docker/weather_discord_bot_for_cloud_run
$ cp .env.sample .env
```

Fill `.env` file.

```
$ docker build -t weather-discord-bot-for-cloud-run .
$ gcloud auth login
$ gcloud auth configure-docker
$ docker tag weather-discord-bot-for-cloud-run gcr.io/[PROJECT-ID]/weather-discord-bot-for-cloud-run
$ docker push gcr.io/[PROJECT-ID]/weather-discord-bot-for-cloud-run
```

## Terraform

```
$ cd [This project directory]/terraform
```

Put `account.json` file from [GCP service account keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-console)

```
$ terraform init
$ terraform plan
$ terraform apply
```