#!/usr/bin/env bash
set -e

SCRIPT_ROOT=$(dirname "${BASH_SOURCE}")
cd $SCRIPT_ROOT

eval $(minikube docker-env)
docker build -t python-http:1.0.1 ..
kubectl apply -f deployments.yaml
kubectl apply -f services.yaml
kubectl wait --for=condition=available --timeout=600s deployment/http-app-1
kubectl wait --for=condition=available --timeout=600s deployment/http-app-2
kubectl wait --for=condition=available --timeout=600s deployment/http-app-3
kubectl get deployments
kubectl get pods -o wide
kubectl get svc
