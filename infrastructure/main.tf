# Neste código é utilizada linguagem declarativa (HCL - Hashicorp Configuration Language)
# para interação com os serviços da Amazon AWS, a fim de se demonstrar os conceitos de IAC (Infrastructure as Code)

# 1 - Criação de um bucket S3 com os parâmetros definidos no arquivo 'variables.tf'
resource "aws_s3_bucket" "datalake" {
  bucket = "${var.base_bucket_name}-${var.environment}-${var.account_number}"
}

#Definição do parâmetro acl como privado
resource "aws_s3_bucket_acl" "datalake" {
  bucket = aws_s3_bucket.datalake.id
  acl    = "private"
}

#Definição da regra de server_side_encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "datalake" {
  bucket = aws_s3_bucket.datalake.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

# 2 - Ingestão de um arquivo no bucket criado anteriormente utilizando codigo
resource "aws_s3_bucket_object" "codigo_spark" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/job_spark_from_tf.py"
  acl    = "private"
  source = "../job_spark_enem2020.py"
  etag   = filemd5("../job_spark_enem2020.py")
}

#Definição do provedor conforme especificado na variavel region
provider "aws" {
  region = var.region
}

