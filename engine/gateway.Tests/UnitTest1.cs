using Microsoft.VisualStudio.TestTools.UnitTesting;
using gateway;

namespace gateway.Tests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {

            var sut = new WorkshopExampleService();
            var result = sut.DoStuff();
            Assert.IsTrue(result == "hallo");
        }
    }
}
