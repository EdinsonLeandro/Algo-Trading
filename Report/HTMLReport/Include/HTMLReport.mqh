//+------------------------------------------------------------------+
//|                                                   HTMLReport.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

struct Str{
   string td[];
};

struct STable{
   Str tr[];
};

struct SSettings{
   string Expert;
   string Symbol;
   string Period;
   string Inputs;
   string Broker;
   string Currency;
   string InitialDeposit;
   string Leverage;
};

struct SInput{
   string Name;
   string Value;
};

struct SResults{
   string HistoryQuality;
   string Bars;
   string Ticks;
   string Symbols;
   string TotalNetProfit;
   string BalanceDrawdownAbsolute;
   string EquityDrawdownAbsolute;
   string GrossProfit;
   string BalanceDrawdownMaximal;
   string EquityDrawdownMaximal;
   string GrossLoss;
   string BalanceDrawdownRelative;
   string EquityDrawdownRelative;
   string ProfitFactor;
   string ExpectedPayoff;
   string MarginLevel;
   string RecoveryFactor;
   string SharpeRatio;
   string ZScore;
   string AHPR;
   string LRCorrelation;
   string OnTesterResult;
   string GHPR;
   string LRStandardError;
   string TotalTrades;
   string ShortTrades_won_pers;
   string LongTrades_won_perc;
   string TotalDeals;
   string ProfitTrades_perc_of_total;
   string LossTrades_perc_of_total;
   string LargestProfitTrade;
   string LargestLossTrade;
   string AverageProfitTrade;
   string AverageLossTrade;
   string MaximumConsecutiveWins_cur;
   string MaximumConsecutiveLosses_cur;
   string MaximalConsecutiveProfit_count;
   string MaximalConsecutiveLoss_count;
   string AverageConsecutiveWins;
   string AverageConsecutiveLosses;
   string Correlation_Profits_MFE;
   string Correlation_Profits_MAE;
   string Correlation_MFE_MAE;      
   string MinimalPositionHoldingTime;
   string MaximalPositionHoldingTime;
   string AveragePositionHoldingTime;
};

struct SOrder{
   string OpenTime;
   string Order;
   string Symbol;
   string Type;
   string Volume;
   string Price;
   string SL;
   string TP;
   string Time;
   string State;
   string Comment;
};

struct SDeal{
   string Time;
   string Deal;
   string Symbol;
   string Type;
   string Direction;
   string Volume;
   string Price;
   string Order;
   string Commission;
   string Swap;
   string Profit;
   string Balance;
   string Comment;
};

struct SSummary{
   string Commission;
   string Swap;
   string Profit;
   string Balance;
};

struct STestingReport{
   SSettings Settings;
   SResults Results;
   SOrder Orders[];
   SDeal Deals[];
   SSummary Summary;
};

struct SPass{
   string Pass;
   string Result;
   string Profit;
   string ExpectedPayoff;
   string ProfitFactor;
   string RecoveryFactor;
   string SharpeRatio;
   string Custom;
   string EquityDD_perc;
   string Trades;
   string Parameters[];
};

struct SOptimization{
   string ParameterName[];
   SPass Pass[];
};

struct SHistoryInfo{
   string Name;
   string Account;
   string Broker;
   string Date;
};

struct SDeposit{
   string Balance;
   string FreeMargin;
   string CreditFacility;
   string Margin;
   string FloatingPL;
   string MarginLevel;
   string Equity;
};

struct SHistoryResults{
   string TotalNetProfit;
   string GrossProfit;
   string GrossLoss;
   string ProfitFactor;
   string ExpectedPayoff;
   string RecoveryFactor;
   string SharpeRatio;
   string BalanceDrawdownAbsolute;
   string BalanceDrawdownMaximal;
   string BalanceDrawdownRelative;
   string TotalTrades;
   string ShortTrades;
   string LongTrades_won_perc;
   string ProfitTrades_perc_of_total;
   string LossTrades_perc_of_total;
   string LargestProfitTrade;
   string LargestLossTrade;
   string AverageProfitTrade;
   string AverageLossTrade;
   string MaximumConsecutiveWins_cur;
   string MaximumConsecutiveLosses_cur;
   string MaximalConsecutiveProfit_count;
   string MaximalConsecutiveLoss_count;
   string AverageConsecutiveWins;
   string AverageConsecutiveLosses;
};

struct SHistory{
   SHistoryInfo Info;
   SOrder Orders[];
   SDeal Deals[];
   SSummary Summary;  
   SDeposit Deposit;
   SHistoryResults Results;
};

bool HistoryHTMLReportToStruct(string aFileName,SHistory & aHistory){

   STable tables[];

   string FileContent;
   
   if(!FileGetContent(aFileName,FileContent)){
      return(true);
   }

   string tags[]={"td","th"};
   string ttmp[],trtmp[],tdtmp[];
   int tcnt,trcnt,tdcnt;
   
   tcnt=TagsToArray(FileContent,"table",ttmp);

   ArrayResize(tables,tcnt);
   
   for(int i=0;i<tcnt;i++){
      trcnt=TagsToArray(ttmp[i],"tr",trtmp);
      ArrayResize(tables[i].tr,trcnt);      
      for(int j=0;j<trcnt;j++){         
         tdcnt=TagsToArray(trtmp[j],tags,tdtmp);
         ArrayResize(tables[i].tr[j].td,tdcnt);
         for(int k=0;k<tdcnt;k++){  
            tables[i].tr[j].td[k]=RemoveTags(tdtmp[k]);
         }
      }
   } 
    
   aHistory.Info.Name=tables[0].tr[1].td[1];
   aHistory.Info.Account=tables[0].tr[2].td[1];
   aHistory.Info.Broker=tables[0].tr[3].td[1];
   aHistory.Info.Date=tables[0].tr[4].td[1];
   
   int i;   
   
   // orders

   ArrayFree(aHistory.Orders);
   int ocnt=0;
   for(i=8;i<ArraySize(tables[0].tr);i++){
      if(ArraySize(tables[0].tr[i].td)==1){
         break;
      }   
      ArrayResize(aHistory.Orders,ocnt+1);
      aHistory.Orders[ocnt].OpenTime=tables[0].tr[i].td[0];
      aHistory.Orders[ocnt].Order=tables[0].tr[i].td[1];
      aHistory.Orders[ocnt].Symbol=tables[0].tr[i].td[2];
      aHistory.Orders[ocnt].Type=tables[0].tr[i].td[3];
      aHistory.Orders[ocnt].Volume=tables[0].tr[i].td[4];
      aHistory.Orders[ocnt].Price=tables[0].tr[i].td[5];
      aHistory.Orders[ocnt].SL=tables[0].tr[i].td[6];
      aHistory.Orders[ocnt].TP=tables[0].tr[i].td[7];
      aHistory.Orders[ocnt].Time=tables[0].tr[i].td[8];
      aHistory.Orders[ocnt].State=tables[0].tr[i].td[9];
      aHistory.Orders[ocnt].Comment=tables[0].tr[i].td[10];      
      ocnt++;
   }
   
   // deals
   
   i+=2;
   ArrayFree(aHistory.Deals);
   int dcnt=0;
   for(;i<ArraySize(tables[0].tr);i++){
      if(ArraySize(tables[0].tr[i].td)!=13){
         if(ArraySize(tables[0].tr[i].td)==6){
            aHistory.Summary.Commission=tables[0].tr[i].td[1];
            aHistory.Summary.Swap=tables[0].tr[i].td[2];
            aHistory.Summary.Profit=tables[0].tr[i].td[3];
            aHistory.Summary.Balance=tables[0].tr[i].td[4];            
         }
         break;
      }   
      ArrayResize(aHistory.Deals,dcnt+1);   
      aHistory.Deals[dcnt].Time=tables[0].tr[i].td[0];
      aHistory.Deals[dcnt].Deal=tables[0].tr[i].td[1];
      aHistory.Deals[dcnt].Symbol=tables[0].tr[i].td[2];
      aHistory.Deals[dcnt].Type=tables[0].tr[i].td[3];
      aHistory.Deals[dcnt].Direction=tables[0].tr[i].td[4];
      aHistory.Deals[dcnt].Volume=tables[0].tr[i].td[5];
      aHistory.Deals[dcnt].Price=tables[0].tr[i].td[6];
      aHistory.Deals[dcnt].Order=tables[0].tr[i].td[7];
      aHistory.Deals[dcnt].Commission=tables[0].tr[i].td[8];
      aHistory.Deals[dcnt].Swap=tables[0].tr[i].td[9];
      aHistory.Deals[dcnt].Profit=tables[0].tr[i].td[10];
      aHistory.Deals[dcnt].Balance=tables[0].tr[i].td[11];
      aHistory.Deals[dcnt].Comment=tables[0].tr[i].td[12];
      dcnt++;
   }  
   
   // deposit
   
   i+=2;
   
   aHistory.Deposit.Balance=tables[0].tr[i].td[1];
   aHistory.Deposit.FreeMargin=tables[0].tr[i].td[4];
   i++;
   aHistory.Deposit.CreditFacility=tables[0].tr[i].td[1];
   aHistory.Deposit.Margin=tables[0].tr[i].td[4];
   i++;
   aHistory.Deposit.FloatingPL=tables[0].tr[i].td[1];
   aHistory.Deposit.MarginLevel=tables[0].tr[i].td[4];
   i++;
   aHistory.Deposit.Equity=tables[0].tr[i].td[1];   
   
   // result
   
   i+=4;
   
   aHistory.Results.TotalNetProfit=tables[0].tr[i].td[1];
   aHistory.Results.GrossProfit=tables[0].tr[i].td[3];
   aHistory.Results.GrossLoss=tables[0].tr[i].td[5];
   i++;   
   aHistory.Results.ProfitFactor=tables[0].tr[i].td[1];
   aHistory.Results.ExpectedPayoff=tables[0].tr[i].td[3];
   i++;
   aHistory.Results.RecoveryFactor=tables[0].tr[i].td[1];
   aHistory.Results.SharpeRatio=tables[0].tr[i].td[3];
   i+=3;
   aHistory.Results.BalanceDrawdownAbsolute=tables[0].tr[i].td[1];
   aHistory.Results.BalanceDrawdownMaximal=tables[0].tr[i].td[3];
   aHistory.Results.BalanceDrawdownRelative=tables[0].tr[i].td[5];
   i+=2;
   
   aHistory.Results.TotalTrades=tables[0].tr[i].td[1];
   aHistory.Results.ShortTrades=tables[0].tr[i].td[3];
   aHistory.Results.LongTrades_won_perc=tables[0].tr[i].td[5];
   i++;
   aHistory.Results.ProfitTrades_perc_of_total=tables[0].tr[i].td[2];
   aHistory.Results.LossTrades_perc_of_total=tables[0].tr[i].td[4];
   i++;
   aHistory.Results.LargestProfitTrade=tables[0].tr[i].td[2];
   aHistory.Results.LargestLossTrade=tables[0].tr[i].td[4];
   i++;   
   aHistory.Results.AverageProfitTrade=tables[0].tr[i].td[2];
   aHistory.Results.AverageLossTrade=tables[0].tr[i].td[4];
   i++;
   aHistory.Results.MaximumConsecutiveWins_cur=tables[0].tr[i].td[2];
   aHistory.Results.MaximumConsecutiveLosses_cur=tables[0].tr[i].td[4];
   i++;
   aHistory.Results.MaximalConsecutiveProfit_count=tables[0].tr[i].td[2];
   aHistory.Results.MaximalConsecutiveLoss_count=tables[0].tr[i].td[4];
   i++;
   aHistory.Results.AverageConsecutiveWins=tables[0].tr[i].td[2];
   aHistory.Results.AverageConsecutiveLosses=tables[0].tr[i].td[4];   

   return(true);
}

bool OptimizerXMLReportToStruct(string aFileName,SOptimization & aOptimization){
   
   STable tables[];
   
   string FileContent;
   
   if(!FileGetContentAnsi(aFileName,FileContent)){
      return(true);
   }   

   string ttmp[],trtmp[],tdtmp[];
   int tcnt,trcnt,tdcnt;
   
   tcnt=TagsToArray(FileContent,"Table",ttmp);

   ArrayResize(tables,tcnt);
   
   for(int i=0;i<tcnt;i++){
      trcnt=TagsToArray(ttmp[i],"Row",trtmp);
      ArrayResize(tables[i].tr,trcnt);      
      for(int j=0;j<trcnt;j++){         
         tdcnt=TagsToArray(trtmp[j],"Cell",tdtmp);
         ArrayResize(tables[i].tr[j].td,tdcnt);
         for(int k=0;k<tdcnt;k++){  
            tables[i].tr[j].td[k]=RemoveTags(tdtmp[k]);
         }
      }
   }      
   
   int pc=ArraySize(tables[0].tr[0].td)-10;
   ArrayResize(aOptimization.ParameterName,pc);
   for(int i=0;i<pc;i++){
      aOptimization.ParameterName[i]=tables[0].tr[0].td[10+i];
   }   
   
   ArrayResize(aOptimization.Pass,ArraySize(tables[0].tr)-1);
   for(int i=1;i<ArraySize(tables[0].tr);i++){
      int k=i-1;
      aOptimization.Pass[k].Pass=tables[0].tr[i].td[0];
      aOptimization.Pass[k].Result=tables[0].tr[i].td[1];
      aOptimization.Pass[k].Profit=tables[0].tr[i].td[2];
      aOptimization.Pass[k].ExpectedPayoff=tables[0].tr[i].td[3];
      aOptimization.Pass[k].ProfitFactor=tables[0].tr[i].td[4];
      aOptimization.Pass[k].RecoveryFactor=tables[0].tr[i].td[5];
      aOptimization.Pass[k].SharpeRatio=tables[0].tr[i].td[6];
      aOptimization.Pass[k].Custom=tables[0].tr[i].td[7];
      aOptimization.Pass[k].EquityDD_perc=tables[0].tr[i].td[8];
      aOptimization.Pass[k].Trades=tables[0].tr[i].td[9];
      ArrayResize(aOptimization.Pass[k].Parameters,pc);
      for(int j=0;j<pc;j++){
         aOptimization.Pass[k].Parameters[j]=tables[0].tr[i].td[10+j];
      }      
   }
   return(true);
}

bool TestingHTMLReportToStruct2(string aFileName){

   STable tables[];

   string FileContent;
   
   if(!FileGetContent(aFileName,FileContent)){
      return(true);
   }

   string tags[]={"td","th"};
   string ttmp[],trtmp[],tdtmp[];
   int tcnt,trcnt,tdcnt;
   
   tcnt=TagsToArray(FileContent,"table",ttmp);
   ArrayResize(tables,tcnt);
   
   for(int i=0;i<tcnt;i++){
      trcnt=TagsToArray(ttmp[i],"tr",trtmp);
      ArrayResize(tables[i].tr,trcnt);      
      for(int j=0;j<trcnt;j++){         
         tdcnt=TagsToArray(trtmp[j],tags,tdtmp);
         ArrayResize(tables[i].tr[j].td,tdcnt);
         for(int k=0;k<tdcnt;k++){  
            tables[i].tr[j].td[k]=RemoveTags(tdtmp[k]);
         }
      }
   }    
   return(true);  
}   

bool TestingHTMLReportToStruct(string aFileName,STestingReport & aTestingReport){

   STable tables[];

   string FileContent;
   
   if(!FileGetContent(aFileName,FileContent)){
      return(true);
   }

   string tags[]={"td","th"};
   string ttmp[],trtmp[],tdtmp[];
   int tcnt,trcnt,tdcnt;
   
   tcnt=TagsToArray(FileContent,"table",ttmp);

   ArrayResize(tables,tcnt);
   
   for(int i=0;i<tcnt;i++){
      trcnt=TagsToArray(ttmp[i],"tr",trtmp);
      ArrayResize(tables[i].tr,trcnt);      
      for(int j=0;j<trcnt;j++){         
         tdcnt=TagsToArray(trtmp[j],tags,tdtmp);
         ArrayResize(tables[i].tr[j].td,tdcnt);
         for(int k=0;k<tdcnt;k++){  
            tables[i].tr[j].td[k]=RemoveTags(tdtmp[k]);
         }
      }
   }   
   
   // settings section
   
   aTestingReport.Settings.Expert=tables[0].tr[4].td[1];
   aTestingReport.Settings.Symbol=tables[0].tr[5].td[1];
   aTestingReport.Settings.Period=tables[0].tr[6].td[1];
   aTestingReport.Settings.Inputs=tables[0].tr[7].td[1];
   int i=8;
   while(i<ArraySize(tables[0].tr) && tables[0].tr[i].td[0]==""){
      aTestingReport.Settings.Inputs=aTestingReport.Settings.Inputs+", "+tables[0].tr[i].td[1];
      i++;
   }
   aTestingReport.Settings.Broker=tables[0].tr[i++].td[1];
   aTestingReport.Settings.Currency=tables[0].tr[i++].td[1];  
   aTestingReport.Settings.InitialDeposit=tables[0].tr[i++].td[1];
   aTestingReport.Settings.Leverage=tables[0].tr[i++].td[1];   
   
   // results section
   
   i+=2;
   aTestingReport.Results.HistoryQuality=tables[0].tr[i++].td[1];
   aTestingReport.Results.Bars=tables[0].tr[i].td[1];
   aTestingReport.Results.Ticks=tables[0].tr[i].td[3];
   aTestingReport.Results.Symbols=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.TotalNetProfit=tables[0].tr[i].td[1];
   aTestingReport.Results.BalanceDrawdownAbsolute=tables[0].tr[i].td[3];
   aTestingReport.Results.EquityDrawdownAbsolute=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.GrossProfit=tables[0].tr[i].td[1];
   aTestingReport.Results.BalanceDrawdownMaximal=tables[0].tr[i].td[3];
   aTestingReport.Results.EquityDrawdownMaximal=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.GrossLoss=tables[0].tr[i].td[1];
   aTestingReport.Results.BalanceDrawdownRelative=tables[0].tr[i].td[3];
   aTestingReport.Results.EquityDrawdownRelative=tables[0].tr[i].td[5];
   i+=2;
   aTestingReport.Results.ProfitFactor=tables[0].tr[i].td[1];
   aTestingReport.Results.ExpectedPayoff=tables[0].tr[i].td[3];
   aTestingReport.Results.MarginLevel=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.RecoveryFactor=tables[0].tr[i].td[1];
   aTestingReport.Results.SharpeRatio=tables[0].tr[i].td[3];
   aTestingReport.Results.ZScore=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.AHPR=tables[0].tr[i].td[1];
   aTestingReport.Results.LRCorrelation=tables[0].tr[i].td[3];
   aTestingReport.Results.OnTesterResult=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.GHPR=tables[0].tr[i].td[1];
   aTestingReport.Results.LRStandardError=tables[0].tr[i].td[3];
   i+=2;
   aTestingReport.Results.TotalTrades=tables[0].tr[i].td[1];
   aTestingReport.Results.ShortTrades_won_pers=tables[0].tr[i].td[3];
   aTestingReport.Results.LongTrades_won_perc=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.TotalDeals=tables[0].tr[i].td[1];
   aTestingReport.Results.ProfitTrades_perc_of_total=tables[0].tr[i].td[3];
   aTestingReport.Results.LossTrades_perc_of_total=tables[0].tr[i].td[5];
   i++;
   aTestingReport.Results.LargestProfitTrade=tables[0].tr[i].td[2];
   aTestingReport.Results.LargestLossTrade=tables[0].tr[i].td[4];
   i++;
   aTestingReport.Results.AverageProfitTrade=tables[0].tr[i].td[2];
   aTestingReport.Results.AverageLossTrade=tables[0].tr[i].td[4];
   i++;
   aTestingReport.Results.MaximumConsecutiveWins_cur=tables[0].tr[i].td[2];
   aTestingReport.Results.MaximumConsecutiveLosses_cur=tables[0].tr[i].td[4];
   i++;
   aTestingReport.Results.MaximalConsecutiveProfit_count=tables[0].tr[i].td[2];
   aTestingReport.Results.MaximalConsecutiveLoss_count=tables[0].tr[i].td[4];
   i++;
   aTestingReport.Results.AverageConsecutiveWins=tables[0].tr[i].td[2];
   aTestingReport.Results.AverageConsecutiveLosses=tables[0].tr[i].td[4];    
   i+=6;
   aTestingReport.Results.Correlation_Profits_MFE=tables[0].tr[i].td[1];
   aTestingReport.Results.Correlation_Profits_MAE=tables[0].tr[i].td[3];
   aTestingReport.Results.Correlation_MFE_MAE=tables[0].tr[i].td[5];    
   i+=3;
   aTestingReport.Results.MinimalPositionHoldingTime=tables[0].tr[i].td[1];
   aTestingReport.Results.MaximalPositionHoldingTime=tables[0].tr[i].td[3];
   aTestingReport.Results.AveragePositionHoldingTime=tables[0].tr[i].td[5];   
   
   // orders

   ArrayFree(aTestingReport.Orders);
   int ocnt=0;
   for(i=3;i<ArraySize(tables[1].tr);i++){
      if(ArraySize(tables[1].tr[i].td)==1){
         break;
      }   
      ArrayResize(aTestingReport.Orders,ocnt+1);
      aTestingReport.Orders[ocnt].OpenTime=tables[1].tr[i].td[0];
      aTestingReport.Orders[ocnt].Order=tables[1].tr[i].td[1];
      aTestingReport.Orders[ocnt].Symbol=tables[1].tr[i].td[2];
      aTestingReport.Orders[ocnt].Type=tables[1].tr[i].td[3];
      aTestingReport.Orders[ocnt].Volume=tables[1].tr[i].td[4];
      aTestingReport.Orders[ocnt].Price=tables[1].tr[i].td[5];
      aTestingReport.Orders[ocnt].SL=tables[1].tr[i].td[6];
      aTestingReport.Orders[ocnt].TP=tables[1].tr[i].td[7];
      aTestingReport.Orders[ocnt].Time=tables[1].tr[i].td[8];
      aTestingReport.Orders[ocnt].State=tables[1].tr[i].td[9];
      aTestingReport.Orders[ocnt].Comment=tables[1].tr[i].td[10];      
      ocnt++;
   }
   
   // deals
   
   i+=3;
   ArrayFree(aTestingReport.Deals);
   int dcnt=0;
   for(;i<ArraySize(tables[1].tr);i++){
      if(ArraySize(tables[1].tr[i].td)!=13){
         if(ArraySize(tables[1].tr[i].td)==6){
            aTestingReport.Summary.Commission=tables[1].tr[i].td[1];
            aTestingReport.Summary.Swap=tables[1].tr[i].td[2];
            aTestingReport.Summary.Profit=tables[1].tr[i].td[3];
            aTestingReport.Summary.Balance=tables[1].tr[i].td[4];            
         }
         break;
      }   
      ArrayResize(aTestingReport.Deals,dcnt+1);   
      aTestingReport.Deals[dcnt].Time=tables[1].tr[i].td[0];
      aTestingReport.Deals[dcnt].Deal=tables[1].tr[i].td[1];
      aTestingReport.Deals[dcnt].Symbol=tables[1].tr[i].td[2];
      aTestingReport.Deals[dcnt].Type=tables[1].tr[i].td[3];
      aTestingReport.Deals[dcnt].Direction=tables[1].tr[i].td[4];
      aTestingReport.Deals[dcnt].Volume=tables[1].tr[i].td[5];
      aTestingReport.Deals[dcnt].Price=tables[1].tr[i].td[6];
      aTestingReport.Deals[dcnt].Order=tables[1].tr[i].td[7];
      aTestingReport.Deals[dcnt].Commission=tables[1].tr[i].td[8];
      aTestingReport.Deals[dcnt].Swap=tables[1].tr[i].td[9];
      aTestingReport.Deals[dcnt].Profit=tables[1].tr[i].td[10];
      aTestingReport.Deals[dcnt].Balance=tables[1].tr[i].td[11];
      aTestingReport.Deals[dcnt].Comment=tables[1].tr[i].td[12];
      dcnt++;
   }
   return(true);
}

string RemoveTags(string aStr){
   string rstr="";
   int e,s=0;
   while((e=StringFind(aStr,"<",s))!=-1){
      if(e>s){
         rstr=rstr+StringSubstr(aStr,s,e-s);
      }
      s=StringFind(aStr,">",e);
      if(s==-1)break;
      s++;
   }
   if(s!=-1){
      rstr=rstr+StringSubstr(aStr,s,StringLen(aStr)-s);
   }
   StringReplace(rstr,"&nbsp;"," ");
   while(StringReplace(rstr,"  "," ")>0);
   StringTrimLeft(rstr);
   StringTrimRight(rstr);
   return(rstr);
}

int TagsToArray(string aContent,string aTag,string & aArray[]){
   string Tags[1];
   Tags[0]=aTag;
   return(TagsToArray(aContent,Tags,aArray));
}

int TagsToArray(string aContent,string & aTags[],string & aArray[]){
   ArrayResize(aArray,0);
   int e,s=0;
   string tag;
   while((s=TagFind(aContent,aTags,s,tag))!=-1 && !IsStopped()){  
      s=StringFind(aContent,">",s);
      if(s==-1)break;
      s++; 
      e=StringFind(aContent,"</"+tag,s);   
      if(e==-1)break;  
      ArrayResize(aArray,ArraySize(aArray)+1);
      aArray[ArraySize(aArray)-1]=StringSubstr(aContent,s,e-s);  
   }
   return(ArraySize(aArray));
}

int TagFind(string aContent,string & aTags[],int aStart,string & aTag){
   int rp=-1;
   for(int i=0;i<ArraySize(aTags);i++){
      int p=StringFind(aContent,"<"+aTags[i],aStart);
      if(p!=-1){
         if(rp==-1){
            rp=p;
            aTag=aTags[i];
         }
         else{
            if(p<rp){
               rp=p;
               aTag=aTags[i];
            }
         }      
      }
   }
   return(rp);
}

bool FileGetContent(string aFileName,string & aContent){
   int h=FileOpen(aFileName,FILE_READ|FILE_TXT);
   if(h==-1)return(false);
   aContent="";
   while(!FileIsEnding(h)){
      aContent=aContent+FileReadString(h);
   }
   FileClose(h);
   return(true);
}

bool FileGetContentAnsi(string aFileName,string & aContent){
   int h=FileOpen(aFileName,FILE_READ|FILE_TXT|FILE_ANSI);
   if(h==-1)return(false);
   aContent="";
   while(!FileIsEnding(h)){
      aContent=aContent+FileReadString(h);
   }
   FileClose(h);
   return(true);
}

string Volume1(string aStr){
   int p=StringFind(aStr,"/",0);
   if(p!=-1){
      aStr=StringSubstr(aStr,0,p);
   }
   StringTrimLeft(aStr);
   StringTrimRight(aStr);
   return(aStr);
}

string Volume2(string aStr){
   int p=StringFind(aStr,"/",0);
   if(p!=-1){
      aStr=StringSubstr(aStr,p+1);
   }
   StringTrimLeft(aStr);
   StringTrimRight(aStr);
   return(aStr);
}

string Value1(string aStr){
   int p=StringFind(aStr,"(",0);
   if(p!=-1){
      aStr=StringSubstr(aStr,0,p);
   }
   StringTrimLeft(aStr);
   StringTrimRight(aStr);
   return(aStr);
}

string Value2(string aStr){
   int p=StringFind(aStr,"(",0);
   if(p!=-1){
      aStr=StringSubstr(aStr,p+1);
   }
   StringReplace(aStr,")","");
   StringReplace(aStr,"%","");
   StringTrimLeft(aStr);
   StringTrimRight(aStr);
   return(aStr);
}

void InputsToStruct(string aStr,SInput & aInputs[]){
   string tmp[];
   string tmp2[];
   StringSplit(aStr,',',tmp);
   int sz=ArraySize(tmp);
   ArrayResize(aInputs,sz);
   for(int i=0;i<sz;i++){
      StringSplit(tmp[i],'=',tmp2);
      StringTrimLeft(tmp2[0]);
      StringTrimRight(tmp2[0]);      
      aInputs[i].Name=tmp2[0];
      if(ArraySize(tmp2)>1){
         StringTrimLeft(tmp2[1]);
         StringTrimRight(tmp2[1]);       
         aInputs[i].Value=tmp2[1];
      }
      else{
         aInputs[i].Value="";
      }
   }
}