package clients

import grails.converters.JSON
import grails.plugins.rest.client.RestBuilder
import org.grails.web.json.JSONObject

class ApiClient {
    def rest = new RestBuilder(connectTimeout: 10000, readTimeout: 20000)

    def post(String url, Map form) {

        JSONObject jsonObject = new JSONObject()

        form.each {
            jsonObject.put(it.key, it.value)
        }

        def response = rest.post(url) {
            contentType "application/json"
            json
                {
                    to = ["id" : "1", "name":"juan"]
                    from = ["id":"-1", "name":"fulanito"]
                    msg = "hola"
                    attachment = null
                    sourceApp = "prueba"
                    targetApp = "prueba"
                }
        }

        println "post response"
        println response.json

        response.json
    }
    
    def get(String url, Map params = [:]) {
        def response = rest.get(url) {
            accept("application/json")
        }

        println "get response"
        println response.json

        response.json
    }
}
