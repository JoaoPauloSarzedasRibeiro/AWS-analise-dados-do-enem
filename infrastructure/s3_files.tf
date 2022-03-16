#Ingestão de um arquivo no bucket criado anteriormente utilizando codigo
resource "aws_s3_bucket_object" "codigo_spark" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/job_spark_from_tf.py"
  acl    = "private"
  source = "../job_spark_enem2020.py"
  etag   = filemd5("../job_spark_enem2020.py")
}