global class UpdateSalesBudgets {
    
    public Sales_Budget__c[] sbs = new List<Sales_budget__c>();
    
    public void updateCurrent(string strId, string strYear)
    {
        decimal KLAftermarket = 0; 
        decimal KLBlades = 0; 
        decimal KLCapital = 0; 
        decimal KLServiceRepair = 0; 
        decimal KUKAftermarket =0 ;
        decimal KUKBlades = 0; 
        decimal KUKCapital = 0; 
        decimal KUKServiceRepair = 0; 
        decimal MCLAftermarket = 0; 
        decimal MCLCapital = 0;
        decimal MCLServiceRepair = 0; 
        decimal RADBlades = 0; 
        decimal RADServiceRepair = 0;
        decimal JFAftermarket = 0; 
        decimal JFCapital = 0; 
        decimal JFServiceRepair = 0; 
        decimal KJEAftermarket = 0; 
        decimal KJECapital = 0; 
        decimal KJEInstallation = 0;
        decimal KJESCSystems = 0; 
        decimal KJEServiceRepair = 0;
        decimal FLKLAftermarket = 0;
        decimal FLKLCapital = 0;
        decimal SPAM = 0;
        decimal SPSB = 0;
        decimal SPCP = 0;
        decimal GSAM = 0;
        decimal GSCP = 0;
        decimal SPRP = 0;
        decimal INCO = 0;
        system.debug(KJESCSystems);
        string BudgetCurrency;
                
        AggregateResult [] asts = [Select sales_budget__c, CurrencyIsoCode CUR, Sum(DCF_MCL_AfterMarket__c) MCLA, Sum(DCF_MCL_Capital__c) MCLC, Sum(DCF_MCL_Serv_Repair__c) MCLSR, 
                                   Sum(DCF_KUK_AfterMarket__c) KUKA, Sum(DCF_KUK_Capital__c) KUKC, Sum(DCF_KUK_Serv_Repair__c) KUKSR, Sum(DCF_KUK_Blades__c) KUKB, 
                                   Sum(DCF_KL_AfterMarket__c) KLA, Sum(DCF_KL_Capital__c) KLC, Sum(DCF_KL_Serv_Repair__c) KLSR, Sum(DCF_KL_Blades__c) KLB, 
                                   Sum(DCF_RAD_Serv_Repair__c) RADSR, Sum(DCF_RAD_Blades__c) RADB, Sum(FH_KJE_AfterMarket__c) KJEA, Sum(FH_KJE_Capital__c) KJEC, 
                                   Sum(FH_KJE_Serv_Repair__c) KJESR, Sum(FH_KJE_SCS__c) KJES, Sum(FH_KJE_Installation__c) KJEI, Sum(FH_JF_AfterMarket__c) JFA, 
                                   Sum(FH_JF_Capital__c) JFC, Sum(FH_JF_Serv_Repair__c) JFSR, Sum(FL_KL_Aftermarket__c) KLFLA, Sum(FL_KL_Capital__c) KLFLC,
                                   SUM(SPAM__c) SPAM, SUM(SPSB__c) SPSB, SUM(SPCP__c) SPCP, SUM(GSAM__c) GSAM, SUM(GSCP__c) GSCP, SUM(SPRP__c) SPRP, SUM(INCO__c) INCO
                                   FROM Account_Sales_Targets__c 
                                   where sales_budget__c =:strId and name = :strYear 
                                   group by sales_budget__c, CurrencyIsoCode];
        system.debug(asts);
        if(!asts.isEmpty()){
        for (AggregateResult  ar : asts)
        {       

            if(string.valueOf(ar.get('KLA')) != null){KLAftermarket = Decimal.valueOf(string.valueOf(ar.get('KLA')));}
            if(string.valueOf(ar.get('KLB')) != null){KLBlades = Decimal.valueOf(string.valueOf(ar.get('KLB')));}
            if(string.valueOf(ar.get('KLC')) != null){KLCapital = Decimal.valueOf(string.valueOf(ar.get('KLC')));}
            if(string.valueOf(ar.get('KLSR')) != null){KLServiceRepair = Decimal.valueOf(string.valueOf(ar.get('KLSR')));}
            if(string.valueOf(ar.get('KLFLA')) != null){FLKLAftermarket = Decimal.valueOf(string.valueOf(ar.get('KLFLA')));}
            if(string.valueOf(ar.get('KLFLC')) != null){FLKLCapital = Decimal.valueOf(string.valueOf(ar.get('KLFLC')));}
            if(string.valueOf(ar.get('KUKA')) != null){KUKAftermarket = Decimal.valueOf(string.valueOf(ar.get('KUKA')));}
            if(string.valueOf(ar.get('KUKB')) != null){KUKBlades = Decimal.valueOf(string.valueOf(ar.get('KUKB')));}
            if(string.valueOf(ar.get('KUKC')) != null){KUKCapital = Decimal.valueOf(string.valueOf(ar.get('KUKC')));}
            if(string.valueOf(ar.get('KUKSR')) != null){KUKServiceRepair = Decimal.valueOf(string.valueOf(ar.get('KUKSR')));}
            if(string.valueOf(ar.get('MCLA')) != null){MCLAftermarket = Decimal.valueOf(string.valueOf(ar.get('MCLA')));}
            if(string.valueOf(ar.get('MCLC')) != null){MCLCapital = Decimal.valueOf(string.valueOf(ar.get('MCLC')));}
            if(string.valueOf(ar.get('MCLSR')) != null){MCLServiceRepair = Decimal.valueOf(string.valueOf(ar.get('MCLSR')));}
            if(string.valueOf(ar.get('RADB')) != null){RADBlades = Decimal.valueOf(string.valueOf(ar.get('RADB')));}
            if(string.valueOf(ar.get('RADSR')) != null){RADServiceRepair = Decimal.valueOf(string.valueOf(ar.get('RADSR')));}
            if(string.valueOf(ar.get('JFA')) != null){JFAftermarket = Decimal.valueOf(string.valueOf(ar.get('JFA')));}
            if(string.valueOf(ar.get('JFC')) != null){JFCapital = Decimal.valueOf(string.valueOf(ar.get('JFC')));}
            if(string.valueOf(ar.get('JFSR')) != null){JFServiceRepair = Decimal.valueOf(string.valueOf(ar.get('JFSR')));}
            if(string.valueOf(ar.get('KJEA')) != null){KJEAftermarket = Decimal.valueOf(string.valueOf(ar.get('KJEA')));}
            if(string.valueOf(ar.get('KJEC')) != null){KJECapital = Decimal.valueOf(string.valueOf(ar.get('KJEC')));}
            if(string.valueOf(ar.get('KJEI')) != null){KJEInstallation = Decimal.valueOf(string.valueOf(ar.get('KJEI')));}
            if(string.valueOf(ar.get('KJES')) != null){KJESCSystems = Decimal.valueOf(string.valueOf(ar.get('KJES')));}
            if(string.valueOf(ar.get('KJESR')) != null){KJEServiceRepair = Decimal.valueOf(string.valueOf(ar.get('KJESR')));}
            if(string.valueOf(ar.get('SPAM')) != null){SPAM = Decimal.valueOf(string.valueOf(ar.get('SPAM')));}
            if(string.valueOf(ar.get('SPSB')) != null){SPSB = Decimal.valueOf(string.valueOf(ar.get('SPSB')));}
            if(string.valueOf(ar.get('SPCP')) != null){SPCP = Decimal.valueOf(string.valueOf(ar.get('SPCP')));}
            if(string.valueOf(ar.get('GSAM')) != null){GSAM = Decimal.valueOf(string.valueOf(ar.get('GSAM')));}
            if(string.valueOf(ar.get('GSCP')) != null){GSCP = Decimal.valueOf(string.valueOf(ar.get('GSCP')));}
            if(string.valueOf(ar.get('SPRP')) != null){SPRP = Decimal.valueOf(string.valueOf(ar.get('SPRP')));}
            if(string.valueOf(ar.get('INCO')) != null){INCO = Decimal.valueOf(string.valueOf(ar.get('INCO')));}
            BudgetCurrency = string.valueOf(ar.get('CUR'));
            system.debug(KJEServiceRepair);
        }

        system.debug(BudgetCurrency);
        double CurrencyRate=[SELECT conversionrate FROM currencytype WHERE isocode =: BudgetCurrency LIMIT 1].conversionrate; 
        system.debug(CurrencyRate);
        
        List<Sales_Budget__c> sbs1 = [SELECT Id, Name, CurrencyIsoCode
                FROM Sales_budget__c
                WHERE id = :strId And Year__c = :strYear Limit 1];
        system.debug(sbs1);
        system.debug(strId);
        system.debug(strYear);

        if(sbs1.size() > 0)
        {
            for (Sales_Budget__c a : sbs1)
            {
                a.DCF_KL_Aftermarket_Account_Totals__c = 0; 
                a.DCF_KL_Blades_Account_Totals__c = 0; 
                a.DCF_KL_Capital_Account_Totals__c = 0; 
                a.DCF_KL_ServiceRepair_Account_Totals__c = 0;
                a.FL_KL_Aftermarket_Account_Totals__c = 0;
                a.FL_KL_Capital_Account_Totals__c = 0;
                a.DCF_KUK_Aftermarket_Account_Totals__c = 0;
                a.DCF_KUK_Blades_Account_Totals__c = 0; 
                a.DCF_KUK_Capital_Account_Totals__c = 0; 
                a.DCF_KUK_ServiceRepair_Account_Totals__c = 0; 
                a.DCF_MCL_Aftermarket_Account_Totals__c = 0; 
                a.DCF_MCL_Capital_Account_Totals__c = 0;
                a.DCF_MCL_ServiceRepair_Account_Totals__c = 0; 
                a.DCF_RAD_Blades_Account_Totals__c = 0; 
                a.DCF_RAD_ServiceRepair_Account_Totals__c = 0;
                a.FH_JF_Aftermarket_Account_Totals__c = 0; 
                a.FH_JF_Capital_Account_Totals__c = 0; 
                a.FH_JF_ServiceRepair_Account_Totals__c = 0; 
                a.FH_KJE_Aftermarket_Account_Totals__c = 0; 
                a.FH_KJE_Capital_Account_Totals__c = 0; 
                a.FH_KJE_Installation_Account_Totals__c = 0;
                a.FH_KJE_SC_Systems_Account_Totals__c = 0; 
                a.FH_KJE_ServiceRepair_Account_Totals__c = 0; 
                a.SPAM_Account_Totals__c = 0; 
                a.SPSB_Account_Totals__c = 0; 
                a.SPCP_Account_Totals__c = 0; 
                a.GSAM_Account_Totals__c = 0; 
                a.GSCP_Account_Totals__c = 0; 
                a.SPRP_Account_Totals__c = 0; 
                a.INCO_Account_Totals__c = 0; 
                a.DCF_KL_Aftermarket_Account_Totals__c += (KLAftermarket*CurrencyRate); 
                a.DCF_KL_Blades_Account_Totals__c += (KLBlades*CurrencyRate); 
                a.DCF_KL_Capital_Account_Totals__c += (KLCapital*CurrencyRate); 
                a.DCF_KL_ServiceRepair_Account_Totals__c += (KLServiceRepair*CurrencyRate); 
                a.FL_KL_Aftermarket_Account_Totals__c += (FLKLAftermarket*CurrencyRate);
                a.FL_KL_Capital_Account_Totals__c += (FLKLCapital*CurrencyRate);
                a.DCF_KUK_Aftermarket_Account_Totals__c +=  (KUKAftermarket*CurrencyRate);
                a.DCF_KUK_Blades_Account_Totals__c += (KUKBlades*CurrencyRate); 
                a.DCF_KUK_Capital_Account_Totals__c += (KUKCapital*CurrencyRate); 
                a.DCF_KUK_ServiceRepair_Account_Totals__c += (KUKServiceRepair*CurrencyRate); 
                a.DCF_MCL_Aftermarket_Account_Totals__c += (MCLAftermarket*CurrencyRate); 
                a.DCF_MCL_Capital_Account_Totals__c +=  (MCLCapital*CurrencyRate);
                a.DCF_MCL_ServiceRepair_Account_Totals__c += (MCLServiceRepair*CurrencyRate); 
                a.DCF_RAD_Blades_Account_Totals__c += (RADBlades*CurrencyRate); 
                a.DCF_RAD_ServiceRepair_Account_Totals__c +=    (RADServiceRepair*CurrencyRate);
                a.FH_JF_Aftermarket_Account_Totals__c += (JFAftermarket*CurrencyRate); 
                a.FH_JF_Capital_Account_Totals__c += (JFCapital*CurrencyRate); 
                a.FH_JF_ServiceRepair_Account_Totals__c += (JFServiceRepair*CurrencyRate); 
                a.FH_KJE_Aftermarket_Account_Totals__c += (KJEAftermarket*CurrencyRate); 
                a.FH_KJE_Capital_Account_Totals__c += (KJECapital*CurrencyRate); 
                a.FH_KJE_Installation_Account_Totals__c +=  (KJEInstallation*CurrencyRate);
                a.FH_KJE_SC_Systems_Account_Totals__c += (KJESCSystems*CurrencyRate); 
                a.FH_KJE_ServiceRepair_Account_Totals__c += (KJEServiceRepair*CurrencyRate); 
                a.SPAM_Account_Totals__c += (SPAM*CurrencyRate); 
                a.SPSB_Account_Totals__c += (SPSB*CurrencyRate); 
                a.SPCP_Account_Totals__c += (SPCP*CurrencyRate); 
                a.GSAM_Account_Totals__c += (GSAM*CurrencyRate); 
                a.GSCP_Account_Totals__c += (GSCP*CurrencyRate); 
                a.SPRP_Account_Totals__c += (SPRP*CurrencyRate); 
                a.INCO_Account_Totals__c += (INCO*CurrencyRate); 
                sbs.add(sbs1[0]);
            }
            if(!sbs.isEmpty())
            {
                update sbs;
                sbs.clear();
            }
        }
    } 
    }

}