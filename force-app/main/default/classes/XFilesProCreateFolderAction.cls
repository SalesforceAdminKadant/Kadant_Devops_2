public class XFilesProCreateFolderAction {
  @InvocableMethod(label='Create XFilesPro Folder' description='Create an XFilesPro Folder for a given record.' category='Global')

    public static List<String> createXFileProFolders(List<ID> ids)
    {
        if(ids.size() > 0)
        {
            XFILES__Xfile_Manage_Folder_Hierarchy__c xfileFolderHierarchy;

            xfileFolderHierarchy = XFILES__Xfile_Manage_Folder_Hierarchy__c.getValues(ids[0].getsobjecttype().getDescribe().getName());

            if(xfileFolderHierarchy != null)
            {
                if(String.isNotBlank(xfileFolderHierarchy.XFILES__Provider_Type__c) && xfileFolderHierarchy.XFILES__Provider_Type__c.equalsIgnoreCase('SharePoint'))
                {
                    for (ID recordID : ids)
                    {
                        XFILES.XfileCopyFolderTemplate.copyTemplateFolder(String.valueOf(recordID));
                    }
                }
            }
        }
        return ids;
    }
}