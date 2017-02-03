﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.3053
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClientTestOneWay.StockService {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="StockService.IStockService")]
    public interface IStockService {
        
        [System.ServiceModel.OperationContractAttribute(IsOneWay=true, Action="http://tempuri.org/IStockService/DoBigAnalysisFast")]
        void DoBigAnalysisFast(string ticker);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IStockService/DoBigAnalysisSlow", ReplyAction="http://tempuri.org/IStockService/DoBigAnalysisSlowResponse")]
        void DoBigAnalysisSlow(string ticker);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
    public interface IStockServiceChannel : ClientTestOneWay.StockService.IStockService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
    public partial class StockServiceClient : System.ServiceModel.ClientBase<ClientTestOneWay.StockService.IStockService>, ClientTestOneWay.StockService.IStockService {
        
        public StockServiceClient() {
        }
        
        public StockServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public StockServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public StockServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public StockServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public void DoBigAnalysisFast(string ticker) {
            base.Channel.DoBigAnalysisFast(ticker);
        }
        
        public void DoBigAnalysisSlow(string ticker) {
            base.Channel.DoBigAnalysisSlow(ticker);
        }
    }
}