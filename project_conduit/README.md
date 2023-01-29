## Step №1. Build Dockerfile

```bash
docker build -t fe-builder .
```

## Step №2. Create your bucket in aws s3.

## Step №3. Run and push to aws S3

```bash
docker run -it -v "ts-redux-react-realworld-example-app":"/app" \
-e AWS_ACCESS_KEY_ID='USE YOUR KEY' \
-e AWS_SECRET_ACCESS_KEY='USE YOUR SECRET KEY' \
-e AWS_DEFAULT_REGION='CHOOSE ANY REGIONS' \
-w "/app" \
fe-builder \
/bin/bash -c 'npm clean-install && npm run build && aws s3 sync ./build/ s3://YOUR_BUCKET_URL'
```

## Step №4. Create a CloudFront Distributions

## Step №5. Add bucket policy.

## Step №6. Add Default root object(index.html) in your "Distribution"

## Resault
[Frontend](https://d262zqwvlu3mjk.cloudfront.net/#/)

