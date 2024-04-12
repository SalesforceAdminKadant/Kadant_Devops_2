public class StringToBlobToBase64 {
    @InvocableMethod(label='Convert String to Blob and to Base64' description='This function is used to convert a string to Blob and then to Base64')
    public static List<String> convertString2Blob2Base64(List<String> strings)
    {
        List<String> strConvertedStrings = new List<String>();
        for (String str : strings) {
            strConvertedStrings.add(EncodingUtil.base64Encode(Blob.valueOf(str)));
        }
        return strConvertedStrings;
    }
}