global class UpdateFollowsInvocable {
   @InvocableMethod
   public static void deleteUserFollows(List<String> ids) {

      for (String strID : ids) {
        UpdateFollowingBatch uf = new UpdateFollowingBatch(strID);
        database.executebatch(uf, 1);
      }

   }
}