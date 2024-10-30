aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name test_lambda \
  --payload '{}' \
  response.json
