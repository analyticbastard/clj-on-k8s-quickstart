(ns hey.core
  (:gen-class)
  (:require [org.httpkit.server :as s]))

(defn handler [my-name request]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body (format "Hello %s from Clojure, Docker, and Kubernetes." my-name)})

(defn -main [& args]
  (let [my-name (or (System/getenv "MY_NAME") 
                    "World")
        port (or (try (Long/parseLong (System/getenv "PORT")) (catch Exception _))
                 3000)]
    (s/run-server (partial handler my-name) {:port port})))
