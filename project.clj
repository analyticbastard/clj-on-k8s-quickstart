(defproject hey "0.0.1"
  :dependencies [[org.clojure/clojure "1.9.0"]
                 [http-kit "2.1.18"]]
  :plugins [[lein-jlink "0.2.0"]]

  ; -- todo cleanup: some of these might be redundant due to testing with ring/jetty
  :jlink-modules ["java.base" "java.logging" "java.sql" "java.naming" "java.desktop" "java.xml.bind"]

  ;; java.xml.bind belongs to J2EE and is not included in the SE JDK
  :jvm-opts ["--add-modules" "java.xml.bind"]
  :aot :all
  :main hey.core)
