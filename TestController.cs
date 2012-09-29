public class TestController : System.Web.Http.ApiController 
{ 
    public string Get() { 
        return "Hello World";
    } 

    public string Get(int id) { 
        return "Hello "+id;
    }
}
