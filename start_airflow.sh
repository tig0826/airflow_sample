
#dagのマウント先
mkdir ./dags

#Dockerfileのベースの作成
cat <<EOS > Dockerfile
FROM apache/airflow
COPY . .
EOS

#build
docker build --tag mydags:0.0.1 .

#helm
helm repo add apache-airflow https://airflow.apache.org
helm repo update

#create namespace
export NAMESPACE=airflow-practice
kubectl create namespace $NAMESPACE

#install helm chart
export RELEASE_NAME=airflow-release
helm install $RELEASE_NAME apache-airflow/airflow --namespace $NAMESPACE

helm upgrade $RELEASE_NAME apache-airflow/airflow --namespace $NAMESPACE \
-- set images.airflow.repository=my-dags \
-- set images.airflow.tag=0.0.1
