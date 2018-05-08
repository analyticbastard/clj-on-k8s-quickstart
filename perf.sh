measure() {
    DELTA=0.01
    tm=0.0
    while kubectl get pods --selector $1 | grep "Pending"; do
        sleep "${DELTA}s";
        tm=$(echo $tm + $DELTA);
    done

    echo $tm
}

delete() {
    running=$(kubectl get pods --selector $1 | grep "Running" | cut -d" " -f 1)
    kubectl delete pod $running >/dev/null 2>/dev/null;
}

doperf() {
    for i in $(seq 1 $1); do
        echo $(measure "name=hello-clj")
        delete "name=hello-clj";
    done
}

echo $(doperf $1)