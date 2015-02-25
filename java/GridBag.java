import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

//<applet code="GridBag.class" height=100 width=100></applet>

public class GridBag extends JApplet
{
	JButton b1;
	JButton b2;
	JButton b3;


	/*JPanel mainpanel;*/
	JPanel gridpanel;


	GridBagLayout gb1;
	GridBagConstraints gbc;


	public void init()
	{
		b1=new JButton("Button1");
		b2=new JButton("Button2");
		b3=new JButton("Button3");

		gridpanel=(JPanel)getContentPane();

		gb1=new GridBagLayout();
		gbc=new GridBagConstraints();
		gridpanel.setLayout(gb1);

		gbc.anchor=GridBagConstraints.NORTHWEST;
		gbc.gridx=0;
		gbc.gridy=0;
		gbc.gridwidth=1;
		gbc.gridheight=1;
		gb1.setConstraints(b1,gbc);
		gridpanel.add(b1);


		gbc.anchor=GridBagConstraints.NORTHWEST;
		gbc.gridx=0;
		gbc.gridy=4;
		gbc.gridwidth=1;
		gbc.gridheight=1;
		gb1.setConstraints(b2,gbc);
		gridpanel.add(b2);


		gbc.anchor=GridBagConstraints.NORTHWEST;
		gbc.gridx=0;
		gbc.gridy=8;
		gbc.gridwidth=1;
		gbc.gridheight=1;
		gb1.setConstraints(b3,gbc);
		gridpanel.add(b3);




	}

}
		
