module builder.builderTest;

import gtk.Builder;
import gtk.Button;
import gtk.Main;
import gtk.Widget;
import gtk.Window;
import gtk.TextView;
import gtk.Entry;
import gtk.FileChooserDialog;

import gobject.Type;

import std.stdio;

class KeepAliveGui
{
	void create(string[] arguments)
	{
		Main.init(arguments);
		builder_ = new Builder();

		if(!builder_.addFromFile("keephdalivegui.glade") )
		{
			writeln("Failed to find keephdalivegui.glade file!");
		}

		mainWindow_ = cast(Window)builder_.getObject("mainWindow");

		if(mainWindow_ !is null)
		{
			mainWindow_.setTitle("Keeping Your Hard Drive Alive!");
			mainWindow_.addOnHide(delegate void(Widget aux) { Main.quit(); });

			addControls();
			mainWindow_.showAll();
		}
		else
		{
			writeln("Failed to create main window!");
		}

		Main.run();
	}

	void addControls()
	{
		Button saveButton = cast(Button)builder_.getObject("saveButton");
		TextView pathsTextView = cast(TextView)builder_.getObject("pathsTextView");
		Entry pathEditBox = cast(Entry)builder_.getObject("pathEditBox");

		pathsTextView.insertText("Blah.....\nAnotherLine\nAnd another line...");

		if(saveButton !is null)
		{
			saveButton.addOnClicked(delegate void(Button aux)
			{
				immutable string text = pathEditBox.getText();

				FileChooserDialog fileChooser = new FileChooserDialog("File Chooser", mainWindow_, FileChooserAction.SELECT_FOLDER);
				fileChooser.run();
				pathEditBox.setText(fileChooser.getFilename());
				fileChooser.hide();
			});
		}

	}

private:
	Builder builder_;
	Window mainWindow_;
}

int main(string[] arguments)
{
	auto gui = new KeepAliveGui;
	gui.create(arguments);

	return 0;
}
