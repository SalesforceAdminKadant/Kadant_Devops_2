global class UpdateSalesBudgetsActuals {
    
    public Sales_Budget__c[] sbs = new List<Sales_budget__c>();
    
    public void updateActuals(string strId, string strYear)
    {
    
    Integer currentYear = date.today().year();   
    date startDate = date.newInstance(currentYear, 01, 01);
    date endDate = date.newInstance(currentYear, 12, 31);  
    system.debug(startDate + 'end date: ' + endDate);
    system.debug(strYear);
    string strDivision = '';
    string strOwnerId = '';
    string BudgetCurrency = '';
    List<String> bcstoinclude = new List<String>();
    
    // Get budget details, including which business categories where budgeted for    
    List<Sales_Budget__c> budgetdetails = [select id, sales_office__c, OwnerId, currencyisocode, DCF_KL_Aftermarket_Total__c,DCF_KL_Blades_Total__c, DCF_KL_Capital_Total__c, DCF_KL_ServiceRepair_Total__c, 
        FL_KL_Aftermarket_Total__c, FL_KL_Capital_Total__c, DCF_KUK_Aftermarket_Total__c, DCF_KUK_Blades_Total__c, DCF_KUK_Capital_Total__c, DCF_KUK_ServiceRepair_Total__c, DCF_MCL_Aftermarket_Total__c,
        DCF_MCL_Capital_Total__c, DCF_MCL_ServiceRepair_Total__c, DCF_RAD_Blades_Total__c, DCF_RAD_ServiceRepair_Total__c, FH_JF_Aftermarket_Total__c, FH_JF_Capital_Total__c, FH_JF_ServiceRepair_Total__c,
        FH_KJE_Aftermarket_Total__c, FH_KJE_Capital_Total__c, FH_KJE_Installation_Total__c, FH_KJE_SC_Systems_Total__c, FH_KJE_ServiceRepair_Total__c, SPAM_Total__c, SPSB_Total__c, SPCP_Total__c, GSAM_Total__c,
        GSCP_Total__c, SPRP_Total__c, INCO_Total__c
        From Sales_Budget__c 
        where Id = :strId limit 1];
        
        for(Sales_Budget__c a: budgetdetails){
            strDivision = a.sales_office__c;
            strOwnerId = a.OwnerId;
            BudgetCurrency = a.currencyisocode;
            if(a.DCF_KL_Aftermarket_Total__c > 0){bcstoinclude.add('DCF-KL-AfterMarket');} 
            if(a.DCF_KL_Blades_Total__c > 0){bcstoinclude.add('DCF-KL-Blades');} 
            if(a.DCF_KL_Capital_Total__c > 0){bcstoinclude.add('DCF-KL-Capital');} 
            if(a.DCF_KL_ServiceRepair_Total__c > 0){bcstoinclude.add('DCF-KL-Service/Repair');}
            if(a.FL_KL_Aftermarket_Total__c > 0){bcstoinclude.add('FP-KL-AfterMarket');}
            if(a.FL_KL_Capital_Total__c > 0){bcstoinclude.add('FP-KL-Capital');}
            if(a.DCF_KUK_Aftermarket_Total__c > 0){bcstoinclude.add('DCF-KUK-AfterMarket');}
            if(a.DCF_KUK_Blades_Total__c > 0){bcstoinclude.add('DCF-KUK-Blades');} 
            if(a.DCF_KUK_Capital_Total__c > 0){bcstoinclude.add('DCF-KUK-Capital ');} 
            if(a.DCF_KUK_ServiceRepair_Total__c > 0){bcstoinclude.add('DCF-KUK-Service/Repair ');} 
            if(a.DCF_MCL_Aftermarket_Total__c > 0){bcstoinclude.add('DCF-MCL-AfterMarket');} 
            if(a.DCF_MCL_Capital_Total__c > 0){bcstoinclude.add('DCF-MCL-Capital');}
            if(a.DCF_MCL_ServiceRepair_Total__c > 0){bcstoinclude.add('DCF-MCL-Service/Repair');} 
            if(a.DCF_RAD_Blades_Total__c > 0){bcstoinclude.add('DCF-RAD-Blades');} 
            if(a.DCF_RAD_ServiceRepair_Total__c > 0){bcstoinclude.add('DCF-RAD-Service/Repair');}
            if(a.FH_JF_Aftermarket_Total__c > 0){bcstoinclude.add('FH-JF-AfterMarket');} 
            if(a.FH_JF_Capital_Total__c > 0){bcstoinclude.add('FH-JF-Capital');} 
            if(a.FH_JF_ServiceRepair_Total__c > 0){bcstoinclude.add('FH-JF-Service/Repair');} 
            if(a.FH_KJE_Aftermarket_Total__c > 0){bcstoinclude.add('FH-KJE-AfterMarket');} 
            if(a.FH_KJE_Capital_Total__c > 0){bcstoinclude.add('FH-KJE-Capital');} 
            if(a.FH_KJE_Installation_Total__c > 0){bcstoinclude.add('FH-KJE-Installation');}
            if(a.FH_KJE_SC_Systems_Total__c > 0){bcstoinclude.add('FH-KJE-S&C Systems');} 
            if(a.FH_KJE_ServiceRepair_Total__c > 0){bcstoinclude.add('FH-KJE-Service/Repair');} 
            if(a.SPAM_Total__c > 0){bcstoinclude.add('SPAM');} 
            if(a.SPSB_Total__c > 0){bcstoinclude.add('SPSB');} 
            if(a.SPCP_Total__c > 0){bcstoinclude.add('SPCP');} 
            if(a.GSAM_Total__c > 0){bcstoinclude.add('GSAM');} 
            if(a.GSCP_Total__c > 0){bcstoinclude.add('GSCP');} 
            if(a.SPRP_Total__c > 0){bcstoinclude.add('SPRP');} 
            if(a.INCO_Total__c > 0){bcstoinclude.add('INCO');} 
        }
        system.debug('Business Cats');
        system.debug(bcstoinclude);
        
        // Get the accounts where the budget owner is on the AccountTeam
        List<AccountTeamMember> accteammbrAccs = [select AccountId from AccountTeamMember where UserId = :strOwnerId];
        List<String> accteammbrIds = new List<String>();

        system.debug('Account Team accounts:');
        system.debug(accteammbrAccs);
        
        for(AccountTeamMember a: accteammbrAccs){
            accteammbrIds.add(a.AccountId); 
        }
        system.debug('Account ids:');
        system.debug(accteammbrIds);
        
      // Get business category totals from orders where budget owner is order owner  
      AggregateResult [] orderownerlines = [SELECT Sum(TotalPrice)thePrice, Business_Category_Text__c bc, Order.CurrencyIsoCode curr
      FROM OrderItem 
      where Order.EffectiveDate >= :startDate
      and Order.EffectiveDate < :endDate
      and Order.Sale_Type__c != 'ICI'
      and Order.Sales_Office_Division__c = :strDivision
      and Order.OwnerId = :strOwnerId                         
      group by Business_Category_Text__c, Order.CurrencyIsoCode];
      
        system.debug(orderownerlines);
      // Get business category totals from orders where budget owner is on the account team and has budgeted for these business categories
      AggregateResult [] accteammbrlines = [SELECT Sum(TotalPrice)thePrice, Business_Category_Text__c bc, Order.CurrencyIsoCode curr
      FROM OrderItem 
      where Order.EffectiveDate >= :startDate
      and Order.EffectiveDate < :endDate
      and Order.Sale_Type__c != 'ICI'
      and Order.Sales_Office_Division__c = :strDivision
      and Order.AccountId IN :accteammbrIds
      and Business_Category_Text__c IN :bcstoinclude                                      
      group by Business_Category_Text__c, Order.CurrencyIsoCode];
      
      system.debug(accteammbrlines);
      
      orderownerlines.addall(accteammbrlines);
      
        // Initialize variables to update
        decimal KLAftermarket = 0; 
        decimal KLBlades = 0;  
        decimal KLCapital = 0; 
        decimal KLServiceRepair = 0; 
        decimal KUKAftermarket = 0; 
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
        
        // assign actual values to variables
        for(AggregateResult ar: orderownerlines){
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KL-AfterMarket'){KLAftermarket = KLAftermarket + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KL-Blades'){KLBlades = KLBlades + Decimal.valueOf(string.valueOf(ar.get('thePrice')));} 
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KL-Capital'){KLCapital = KLCapital + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KL-Service/Repair'){KLServiceRepair = KLServiceRepair + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KUK-AfterMarket'){KUKAftermarket = KUKAftermarket + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KUK-Blades'){KUKBlades = KUKBlades + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KUK-Capital'){KUKCapital = KUKCapital  + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-KUK-Service/Repair'){KUKServiceRepair = KUKServiceRepair + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-MCL-AfterMarket'){MCLAftermarket = MCLAftermarket + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-MCL-Capital'){MCLCapital = MCLCapital + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-MCL-Service/Repair'){MCLServiceRepair = MCLServiceRepair + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-RAD-Blades'){RADBlades = RADBlades  + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'DCF-RAD-Service/Repair'){RADServiceRepair = RADServiceRepair  + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-JF-AfterMarket'){JFAftermarket = JFAftermarket + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-JF-Capital'){JFCapital = JFCapital + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-JF-Service/Repair'){JFServiceRepair = JFServiceRepair + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-KJE-AfterMarket'){KJEAftermarket = KJEAftermarket + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-KJE-Capital'){KJECapital = KJECapital + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-KJE-Installation'){KJEInstallation = KJEInstallation + Decimal.valueOf(string.valueOf(ar.get('thePrice')));} 
        if(string.valueOf(ar.get('BC')) ==  + 'FH-KJE-S&C Systems'){KJESCSystems = KJESCSystems + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FH-KJE-Service/Repair'){KJEServiceRepair = KJEServiceRepair + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FP-KL-AfterMarket'){FLKLAftermarket = FLKLAftermarket + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'FP-KL-Capital'){FLKLCapital = FLKLCapital + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'SPAM'){SPAM = SPAM + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'SPSB'){SPSB = SPSB + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'SPCP'){SPCP = SPCP + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'GSAM'){GSAM = GSAM + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'GSCP'){GSCP = GSCP + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'SPRP'){SPRP = SPRP + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        if(string.valueOf(ar.get('BC')) ==  + 'INCO'){INCO = INCO + Decimal.valueOf(string.valueOf(ar.get('thePrice')));}
        }  
        
       system.debug(KJEAfterMarket + 'KJEAfterMarket');

       // system.debug(BudgetCurrency);
        double CurrencyRate=[SELECT conversionrate FROM currencytype WHERE isocode =: BudgetCurrency LIMIT 1].conversionrate; 
        system.debug(CurrencyRate);
        system.debug(budgetdetails);
        
        if(budgetdetails.size() > 0)
        {
            for (Sales_Budget__c a: budgetdetails)
            {
                a.DCF_KL_Aftermarket_Actuals__c = 0; 
                a.DCF_KL_Blades_Actuals__c = 0;  
                a.DCF_KL_Capital_Actuals__c = 0; 
                a.DCF_KL_ServiceRepair_Actuals__c = 0; 
                a.DCF_KUK_Aftermarket_Actuals__c = 0; 
                a.DCF_KUK_Blades_Actuals__c = 0;  
                a.DCF_KUK_Capital_Actuals__c = 0; 
                a.DCF_KUK_ServiceRepair_Actuals__c = 0; 
                a.DCF_MCL_Aftermarket_Actuals__c = 0; 
                a.DCF_MCL_Capital_Actuals__c = 0; 
                a.DCF_MCL_ServiceRepair_Actuals__c = 0; 
                a.DCF_RAD_Blades_Actuals__c = 0; 
                a.DCF_RAD_ServiceRepair_Actuals__c = 0; 
                a.FH_JF_Aftermarket_Actuals__c = 0; 
                a.FH_JF_Capital_Actuals__c = 0; 
                a.FH_JF_ServiceRepair_Actuals__c = 0; 
                a.FH_KJE_Aftermarket_Actuals__c = 0; 
                a.FH_KJE_Capital_Actuals__c = 0; 
                a.FH_KJE_Installation_Actuals__c = 0;
                a.FH_KJE_SC_Systems_Actuals__c = 0; 
                a.FH_KJE_ServiceRepair_Actuals__c = 0; 
                a.FL_KL_Aftermarket_Actuals__c = 0; 
                a.FL_KL_Capital_Actuals__c = 0;
                a.SPAM_Actuals__c = 0;
                a.SPSB_Actuals__c = 0;
                a.SPCP_Actuals__c = 0;
                a.GSAM_Actuals__c = 0;
                a.GSCP_Actuals__c = 0;
                a.SPRP_Actuals__c = 0;
                a.INCO_Actuals__c = 0;
                a.DCF_KL_Aftermarket_Actuals__c = (KLAftermarket*CurrencyRate); 
                a.DCF_KL_Blades_Actuals__c = (KLBlades*CurrencyRate);  
                a.DCF_KL_Capital_Actuals__c = (KLCapital*CurrencyRate); 
                a.DCF_KL_ServiceRepair_Actuals__c = (KLServiceRepair*CurrencyRate); 
                a.DCF_KUK_Aftermarket_Actuals__c = (KUKAftermarket*CurrencyRate); 
                a.DCF_KUK_Blades_Actuals__c = (KUKBlades*CurrencyRate);  
                a.DCF_KUK_Capital_Actuals__c = (KUKCapital*CurrencyRate); 
                a.DCF_KUK_ServiceRepair_Actuals__c = (KUKServiceRepair*CurrencyRate); 
                a.DCF_MCL_Aftermarket_Actuals__c = (MCLAftermarket*CurrencyRate); 
                a.DCF_MCL_Capital_Actuals__c = (MCLCapital*CurrencyRate); 
                a.DCF_MCL_ServiceRepair_Actuals__c = (MCLServiceRepair*CurrencyRate); 
                a.DCF_RAD_Blades_Actuals__c = (RADBlades*CurrencyRate); 
                a.DCF_RAD_ServiceRepair_Actuals__c = (RADServiceRepair*CurrencyRate); 
                a.FH_JF_Aftermarket_Actuals__c = (JFAftermarket*CurrencyRate); 
                a.FH_JF_Capital_Actuals__c = (JFCapital*CurrencyRate); 
                a.FH_JF_ServiceRepair_Actuals__c = (JFServiceRepair*CurrencyRate); 
                a.FH_KJE_Aftermarket_Actuals__c = (KJEAftermarket*CurrencyRate); 
                a.FH_KJE_Capital_Actuals__c = (KJECapital*CurrencyRate); 
                a.FH_KJE_Installation_Actuals__c = (KJEInstallation*CurrencyRate);
                a.FH_KJE_SC_Systems_Actuals__c = (KJESCSystems*CurrencyRate); 
                a.FH_KJE_ServiceRepair_Actuals__c = (KJEServiceRepair*CurrencyRate); 
                a.FL_KL_Aftermarket_Actuals__c = (FLKLAftermarket*CurrencyRate); 
                a.FL_KL_Capital_Actuals__c = (FLKLCapital*CurrencyRate);
                a.SPAM_Actuals__c = (SPAM*CurrencyRate);
                a.SPSB_Actuals__c = (SPSB*CurrencyRate);
                a.SPCP_Actuals__c = (SPCP*CurrencyRate);
                a.GSAM_Actuals__c = (GSAM*CurrencyRate);
                a.GSCP_Actuals__c = (GSCP*CurrencyRate);
                a.SPRP_Actuals__c = (SPRP*CurrencyRate);
                a.INCO_Actuals__c = (INCO*CurrencyRate);
                sbs.add(budgetdetails[0]);
            }
            system.debug('sbs contains:');
            system.debug(sbs);
            if(!sbs.isEmpty())
            {
                update sbs;
                sbs.clear();
            }
        }
        
    }

}