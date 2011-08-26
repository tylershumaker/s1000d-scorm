package bridge.toolkit.commands;

import org.apache.commons.chain.Command;
import org.apache.commons.chain.Context;

import java.io.File;
import java.util.ArrayList;
import bridge.toolkit.util.Keys;

public class CleanUp implements Command
{
	
	@Override
	public boolean execute(Context ctx)
	{
		
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
		return PROCESSING_COMPLETE;
	}

}
