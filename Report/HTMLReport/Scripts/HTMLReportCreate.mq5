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
   
   string TableHeader[]={  "Time",
                           "Order",
                           "Deal",
                           "Symbol",
                           "Type",
                           "Direction",
                           "Volume",
                           "Price",
                           "Order",
                           "S/L",
                           "T/P",
                           "Time",
                           "State",
                           "Commission",
                           "Swap",
                           "Profit",
                           "Balance",
                           "Comment"};

   SHistory History;
   HistoryHTMLReportToStruct("ReportHistory-555849.html",History);
   
   int h=FileOpen("Report.htm",FILE_WRITE);
   if(h==-1)return;

   FileWriteString(h,HTMLStart("Report"));
   FileWriteString(h,"<table>\n");
   
   FileWriteString(h,"\t<tr>\n");   
   for(int i=0;i<ArraySize(TableHeader);i++){
      FileWriteString(h,"\t\t<th>"+TableHeader[i]+"</th>\n"); 
   }
   FileWriteString(h,"\t</tr>\n");     

   int j=0;
   for(int i=0;i<ArraySize(History.Orders);i++){
      
      string sc="";
      
      if(History.Orders[i].State=="canceled"){
         sc="PendingCancelled";
      }
      else if(History.Orders[i].State=="filled"){
         if(History.Orders[i].Type=="buy"){
            sc="OrderMarketBuy";
         }
         else if(History.Orders[i].Type=="sell"){
            sc="OrderMarketSell";
         }
         if(History.Orders[i].Type=="buy limit" || History.Orders[i].Type=="buy stop"){
            sc="OrderPendingBuy";
         }
         else if(History.Orders[i].Type=="sell limit" || History.Orders[i].Type=="sell stop"){
            sc="OrderMarketSell";
         }         
      }
   
      FileWriteString(h,"\t<tr class=\""+sc+"\">\n");   
      FileWriteString(h,"\t\t<td>"+History.Orders[i].OpenTime+"</td>\n");  // Time
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Order+"</td>\n");     // Order 
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Deal 
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Symbol+"</td>\n");    // Symbol 
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Type+"</td>\n");      // Type 
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Direction       
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Volume+"</td>\n");    // Volume    
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Price+"</td>\n");     // Price  
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Order        
      FileWriteString(h,"\t\t<td>"+History.Orders[i].SL+"</td>\n");        // SL
      FileWriteString(h,"\t\t<td>"+History.Orders[i].TP+"</td>\n");        // TP
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Time+"</td>\n");      // Time    
      FileWriteString(h,"\t\t<td>"+History.Orders[i].State+"</td>\n");     // State
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Comission
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Swap
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Profit     
      FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");                    // Ballance    
      FileWriteString(h,"\t\t<td>"+History.Orders[i].Comment+"</td>\n");   // Comment     
      FileWriteString(h,"\t</tr>\n");   
      
      // Find a deal
      if(History.Orders[i].State=="filled"){
         for(;j<ArraySize(History.Deals);j++){
            if(History.Deals[j].Order==History.Orders[i].Order){
               
               sc="";
               
               if(History.Deals[j].Type=="buy"){
                  sc="DealBuy";
               }
               else if(History.Deals[j].Type=="sell"){
                  sc="DealSell";
               }
            
               FileWriteString(h,"\t<tr class=\""+sc+"\">\n");   
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Time+"</td>\n");     // Time
               FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");     // Order 
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Deal+"</td>\n");     // Deal 
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Symbol+"</td>\n");     // Symbol 
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Type+"</td>\n");     // Type 
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Direction+"</td>\n");     // Direction       
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Volume+"</td>\n");     // Volume    
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Price+"</td>\n");     // Price  
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Order+"</td>\n");     // Order        
               FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");     // SL
               FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");     // TP
               FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");     // Time    
               FileWriteString(h,"\t\t<td>"+"&nbsp;"+"</td>\n");     // State
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Commission+"</td>\n");                    // Comission
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Swap+"</td>\n");     // Swap
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Profit+"</td>\n");     // Profit     
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Balance+"</td>\n");     // Ballance    
               FileWriteString(h,"\t\t<td>"+History.Deals[j].Comment+"</td>\n");     // Comment     
               FileWriteString(h,"\t</tr>\n"); 
               break;
            }
         }
      }          
   }
   
   FileWriteString(h,"</table>\n");   
   FileWriteString(h,HTMLEnd());   

   FileClose(h);
}

string HTMLStart(string aTitle,string aCSSFile="style.css"){
   string str="<!DOCTYPE html>\n";
   str=str+"<html>\n";
   str=str+"<head>\n";
   str=str+"<link href=\""+aCSSFile+"\" rel=\"stylesheet\" type=\"text/css\">\n";
   str=str+"<title>"+aTitle+"</title>\n";
   str=str+"</head>\n";  
   str=str+"<body>\n";     
   return str;
}

string HTMLEnd(){
   string str="</body>\n";
   str=str+"</html>\n";
   return str;
}
