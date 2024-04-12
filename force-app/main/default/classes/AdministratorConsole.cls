global class AdministratorConsole
{
 
  static public PageReference CreateForecast()
  {
        CreateForecastBatch cfb = new CreateForecastBatch();
        cfb.main();
        
        return null;
  }

}