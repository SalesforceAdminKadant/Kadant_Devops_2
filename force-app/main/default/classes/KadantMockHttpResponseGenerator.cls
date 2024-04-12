@isTest
global class KadantMockHttpResponseGenerator implements HttpCalloutMock {

   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"8UT28QKGORMivFqne-6PMRLdTYk3AS0mcxdVwRJEwYsTjwZjqGopk1TRzGX7vHSZpFNFL3HOmX3RKZrQkBap3b16j-XVkwArdDbhusArOBGzYsD1cpA8B87N_RedJrd9btvq2i22cAjPvyJLSVMc297U0V9YZ9rJ3tM429G8mglnsUNUVJJi_nnTJAN6-H038B4Y1aQeRQZVdU72Nr942eYZ3fXv1HXfxwYUZgWyYO5juVaVnoq_ZJHcrFGXfNp5LVrNlnEibHhJ2RGeD-MYKhyVjfkTrATGQhYY--OVCOemUyWKTlwgwBFjgzfpQfOq79raEglOTgEF3Qx78RY2-nBNvgOTRMET4B2fT17Q8EN4UCQLxGZTGq1ACN5j2B3YKT7isjzwAgysloYGJsL4j4D8dCGKgWBO0rTXwx7MfkNsX5TjAYRNCip5vTSRXeSBqhjM_TtwbKCA0HexikSz-XryZT7pKGYhjfRCXtWudd7OUjFYoDRfKTiAhjNk5yJj","token_type":"bearer","expires_in":86400,"userName":"test@gmail.com",".issued":"Thu, 25 Jun 2015 12:56:23 GMT",".expires":"Fri, 26 Jun 2015 12:56:23 GMT"}');
        res.setStatusCode(200);
        return res;
    }
}