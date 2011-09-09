/**
 * This file is part of the S1000D-SCORM Bridge Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.commands;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;

import java.io.File;
import java.util.ArrayList;
import bridge.toolkit.util.Keys;

/**
 * Command that clean out the context object and deletes files if necessary
 */
public class CleanUp implements Command
{
	/**
	 * The unit of processing work to be performed for the Clean up module.
     * @see org.apache.commons.chain.Command#execute(org.apache.commons.chain.Context)
	 */
	@Override
	public boolean execute(Context ctx)
	{
		System.out.println("Executing Clean Up");
		ctx.put(Keys.CP_PACKAGE, null);
		ctx.put(Keys.OUTPUT_DIRECTORY, null);
		
		if (ctx.get(Keys.MOBLIE_FILES_TO_DELETE) != null)
		{
			ArrayList<String> files = (ArrayList<String>)ctx.get(Keys.MOBLIE_FILES_TO_DELETE);
			for (int f = files.size() - 1; f >= 0; f--)
			{
				File temp = new File(files.get(f));
				temp.delete();
			}
			
			ctx.put(Keys.MOBLIE_FILES_TO_DELETE,null);
		}
		System.out.println("Clean Up Complete");
		return PROCESSING_COMPLETE;
	}

}
