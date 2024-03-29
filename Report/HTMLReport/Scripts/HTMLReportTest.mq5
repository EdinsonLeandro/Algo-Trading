//+------------------------------------------------------------------+
//|                                               HTMLReportTest.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <HTMLReport.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart(){
   
   STestingReport TestingReport;
   TestingHTMLReportToStruct("ReportTester-555849.html",TestingReport);
   
   SOptimization Optimization;
   OptimizerXMLReportToStruct("ReportOptimizer-555849.xml",Optimization);
   
   SHistory History;
   HistoryHTMLReportToStruct("ReportHistory-555849.html",History);
   
   Print("ReportTester: ордеров - ",ArraySize(TestingReport.Orders),", сделок - ",ArraySize(TestingReport.Deals));
   Print("ReportOptimizer: проходов - ",ArraySize(Optimization.Pass));
   Print("ReportHistory: ордеров - ",ArraySize(History.Orders),", сделок - ",ArraySize(History.Deals));
}
