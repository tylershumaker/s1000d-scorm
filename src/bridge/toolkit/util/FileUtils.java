package bridge.toolkit.util;

import java.io.File;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FileUtils {

    public static String renameFileExtension(String source, String newExtension)
    {
        String target;
        String currentExtension = getFileExtension(source);

        if (currentExtension.equals("")){
            target = source + "." + newExtension;
        }
        else {
            target = source.replaceFirst(Pattern.quote("." +
                    currentExtension) + "$", Matcher.quoteReplacement("." + newExtension));

        }
        return target;
//        return new File(source).renameTo(new File(target));
    }

    public static String getFileExtension(String f) {
        String ext = "";
        int i = f.lastIndexOf('.');
        if (i > 0 &&  i < f.length() - 1) {
            ext = f.substring(i + 1);
        }
        return ext;
    }

    public static String updateFileExtensionLowerCase(String f) {
        String lowerExt = getFileExtension(f).toLowerCase();

        return renameFileExtension(f, lowerExt);
    }

//    public static List<String> updateFileExtensionsLowerCase(List<String> src_files){
//
//        Iterator<String> filesIterator = src_files.iterator();
//        while(filesIterator.hasNext())
//        {
//            String src = filesIterator.next();
//        }
//
//        return list
//    }

}
