function fn() {
    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    karate.configure('ssl', true);

     var baseUrl = karate.properties['baseUrl'] || 'https://api-sandbox.co.uat.wompi.dev'
     var namespace = karate.properties['version'] || 'v1'

    return {
        api:{
             urlBase: baseUrl + '/'+namespace
        },
        path:{
            merchants:'/merchants/',
            transaction:'/transactions'
        }

    };
}