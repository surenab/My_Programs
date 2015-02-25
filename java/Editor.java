import java.*;
import java.io.*;
import java.awt.*;
import java.awt.event.*;

class Editor extends Frame implements ActionListener,TextListener
{
		 TextArea ta;
		 int flg,pos,cnt,charcnt,i;
		 String fname,editcp,efile;
		 int si,start,openflg;
		 int line[]=new int[5000];
		 int keypres,cpos,replaceflg;

		 public Editor()
		 {
		 		 start=0;cnt=0;charcnt=0;replaceflg=1;
		 		 flg=0;keypres=0;i=0;openflg=0;
		 		 setTitle("Untitled - Java");
		 		 setSize(800,550);

		 		 ta = new TextArea("",20,50);
		 		 ta.addTextListener(this);

		 //////////////////////// Creating MenuBar,Menus & MenuItems
/////////////////////////

		 		 MenuBar mb = new MenuBar();
		 		 setMenuBar(mb);

		 		 Menu file = new Menu("File");
		 		 mb.add(file);
		 		 Menu edit = new Menu("Edit");
		 		 mb.add(edit);
		 		 Menu format = new Menu("Format");
		 		 mb.add(format);
		 		 Menu exec = new Menu("Execution");
		 		 mb.add(exec);
		 		 Menu help = new Menu("Help");
		 		 mb.add(help);

		 		 MenuItem		 new1 = new MenuItem("New");
		 		 file.add(new1);
		 		 new1.addActionListener(this);
                                MenuItem open = new MenuItem("Open...");
		 		 file.add(open);
		 		 open.addActionListener(this);
		 		 MenuItem save = new MenuItem("Save");
		 		 file.add(save);
		 		 save.addActionListener(this);
		 		 MenuItem saveas = new MenuItem("Save As...");
		 		 file.add(saveas);
		 		 saveas.addActionListener(this);
		 		 file.addSeparator();
		 		 MenuItem exit = new MenuItem("Exit");
		 		 file.add(exit);
		 		 exit.addActionListener(this);

		 		 MenuItem cut = new MenuItem("Cut");
		 		 edit.add(cut);
		 		 cut.addActionListener(this);
		 		 MenuItem copy = new MenuItem("Copy");
		 		 edit.add(copy);
		 		 copy.addActionListener(this);
		 		 MenuItem paste = new MenuItem("Paste");
		 		 edit.add(paste);
		 		 paste.addActionListener(this);
		 		 edit.addSeparator();
		 		 MenuItem find = new MenuItem("Find...");
		 		 edit.add(find);
		 		 find.addActionListener(this);
		 		 MenuItem replace1 = new MenuItem("Replace...");
		 		 edit.add(replace1);
		 		 replace1.addActionListener(this);
		 		 edit.addSeparator();
		 		 MenuItem got = new MenuItem("Go To...");
		 		 edit.add(got);
		 		 got.addActionListener(this);
		 		 MenuItem selall = new MenuItem("Select All");
		 		 edit.add(selall);
		 		 selall.addActionListener(this);
		 		 MenuItem delete1 = new MenuItem("Delete");
		 		 edit.add(delete1);
		 		 delete1.addActionListener(this);

		 		 MenuItem fonts = new MenuItem("Font...");
		 		 format.add(fonts);
		 		 fonts.addActionListener(this);

		 		 MenuItem compil = new MenuItem("Compile");
		 		 exec.add(compil);
		 		 compil.addActionListener(this);
		 		 MenuItem run = new MenuItem("Run");
		 		 exec.add(run);
		 		 run.addActionListener(this);

		 		 MenuItem about = new MenuItem("About...");
		 		 help.add(about);
		 		 about.addActionListener(this);

		 ////////////////// Creating MenuBar,Menus & MenuItems Ends Here
//////////////////

		       		 add(ta);
		 		 setVisible(true);

		 		 addWindowListener(new mywind());
		 }


          //////////////////////////// To Get The Values From Font Dialog
Box ///////////////////////////

		 public void setFontValue(String fontn,int fstyle,int fonts)
		 {
		 		 Font fnt = new Font(fontn,fstyle,fonts);
		 		 ta.setFont(fnt);
		 }

           ////////////////////////////////////// Font Dialog Box Ends
Here ////////////////////////////////////


           ////////////////////////////// To Get Values From Dialog Box
////////////////////////////////////

		 public void setValue(int state,String txt,String txt1,int txt2)
		 {
		 		 int stt=state;
		 		 int lpos=txt2;
		 		 int charpos[]=new int[1000];
		 		 int j;

		 ///////////////////////////// Code For GoTo Line Number
/////////////////////////////

		 		 if (stt==1)
		 		  {
		 		 		 StringBuffer strbuf=new StringBuffer(ta.getText());
		 		 		 int len=strbuf.length();
		 		 		 j=0;
		 		 		 for(int i=0;i<len;i++)
		 		 		 {
		 		 		 		 if(strbuf.charAt(i)==10)
		 		 		 		 {
		 		 		 		 		 charpos[j]=i;
		 		 		 		 		 j++;cnt++;
		 		 		 		 }
		 		 		 }

		 		 		 if (lpos>cnt)
		 		 		 {
		 		 		 		 new MsgDlg(this," Out Of Range....!");
		 		 		 }
		 		 		 else
		 		 		 {
		 		 		 		 if(lpos==1)
		 		 		 		 {ta.select(0,charpos[0]);}
		 		 		 		 else
		 		 		 		 {ta.select(charpos[lpos-2],charpos[lpos-1]);}
		 		 		 }
		 		   }

		 //////////////////// Code For GoTo Line Number Ends Here
/////////////////////

		 ///////////// Code For Saving Text When Clicking File -> New
//////////////

		 		 else  if(stt==2)
		 		   {
		 		 		 start=0;
		 		 		 String st = ta.getText();
		 		 		 FileDialog  fd = new FileDialog(this,"Save",FileDialog.SAVE);
		 		 		 fd.setVisible(true);
		 		 		 fname= fd.getDirectory()+fd.getFile();

		 		 		 if(fname!="")
		 		 		 {
		 		 		 try{
		 		 		 		 FileOutputStream fo = new FileOutputStream(fname);
		 		 		 		 int i;
		 		 		 		 for(i=0;i<st.length();i++)
		 		 		 		 {
		 		 		 		 		 fo.write(st.charAt(i));
		 		 		 		 }
		 		 		 		 ta.setText("");
		 		 		 		 Font ft = new Font("Times New Roman",0,12);
		 		 		 		 ta.setFont(ft);
		 		 		 		 setTitle("Untitled - Java");
		 		                		       } catch(IOException ie) {}
		 		 		 }
		 		 }

		 ////////// Code For Saving Text When Clicking File -> New  Ends Here
////////////

		 /////////////////////////////////// Code For Finding Given Text
//////////////////////////////////

		 		 else if(stt==3)
		 		   {
		 		 		 replaceflg=1;
		 		 		 si=ta.getText().indexOf(txt,start);
		 		 		 if(si<0)
		 		 		  {
		 		 		 		 start=0;
		 		 		 		 new MsgDlg(this,"Now....! Word Not Found");
		 		 		 		 replaceflg=0;
 		 		 		   }

		 		 		 else
		 		 		   {
		 		 		 		 ta.select(si,si +txt.length());
		 		 		 		 start = si + txt.length();
		 		 		   }
		 		   }

		 //////////////////////////// Code For Finding Given Text Ends Here
///////////////////////////

		 /////////////////////////////////// Code For Replacing Given Text
/////////////////////////////////

		 		 else if (stt==4)
		 		   {
		 		          if (replaceflg!=0)
		 		             {
		 		 		 StringBuffer sb = new StringBuffer(txt);
		 		                		 String  blk="";
		 		 		 pos=ta.getCaretPosition();
		 		 		 int e=pos+txt1.length();
		 		 		 ta.replaceRange(blk,pos,e);
		 		 		 ta.insert(txt1,pos);
		 		 		 replaceflg=0;
		 		             }
		 		   }

		 /////////////////////////// Code For Replacing Given Text Ends Here
/////////////////////////

		 		 else if (stt==5)
		 		   {
		 		 		 start=0;
		 		 		 ta.setText("");
		 		 		 setTitle("Untitled - Java");
		 		 		 Font ft = new Font("Times New Roman",0,12);
		 		 		 ta.setFont(ft);
		 		 		 ta.setCaretPosition(0);
		 		   }

		 		 else if (stt==0)
                                 {		 start=0;
		 		 		 ta.setText(ta.getText());
		 		  }

		 		 else if(!(stt >= 0 && stt <= 5))
                                 {
		 		 		 start=0;
		 		 		 ta.setText("");
		 		  }
}

           ///////////////////////////////////////  End Of getvalue From
Dialog Box //////////////////////////////////////


          /////////////////////////  For Checking Whether The Key Is
Pressed Or Not ////////////////////////////

		 public void textValueChanged(TextEvent te)
		 {keypres=1;}

          ////////////////////////////////////////// Text Event Ends Here
///////////////////////////////////////////////////////


          ////////////////// To Check Whether The Menu Options Are Checked
Or Not //////////////////

		 public void actionPerformed(ActionEvent ae)
		  {
                      if(ae.getActionCommand() == "New")
		       {
		 		 flg=0;
                          		 if (keypres==1)
		 		 {
		 		  MyDialog md;
		 		  md = new MyDialog(this,"New",3,this,"          Save file (Yes/No)?
");
		 		 }
		 		 else
		 		 {
		 		 		  ta.setText("");
		 		 		 Font ft = new Font("Times New Roman",0,12);
		 		 		 ta.setFont(ft);
		 		 }
    		       }

		      else if(ae.getActionCommand() == "Open...")
		        {
		 		 ta.setCaretPosition(0);
		 		 String tempfname = "Untitled";
		 		 if (openflg != 0) { tempfname=fname; }
		 		 flg = 0;
		 		 FileDialog fd = new FileDialog(this,"Open");
		 		 fd.setVisible(true);
		           		 fname = fd.getDirectory() + fd.getFile();

		 		 if (tempfname.equals("null")) {setTitle("Untitled - Java");}
		 		 else
		 		 {
		 		 		 openflg = 1;
		 		 		 if(fname.equals("nullnull")){fname=tempfname;}
		 		 		 efile = fd.getFile();
		 		 		 setTitle(fname + " - Java");
		 		        try{
		 		 		 FileInputStream fi = new FileInputStream(fname);
		 		 		 int size = fi.available();
		 		 		 byte data[] = new byte[size];
		 		 		 fi.read(data,0,size);
		 		 		 ta.setText(new String(data));
		 		             }catch(FileNotFoundException fe){}
		 		               catch(IOException ie){}

		 		 }

                         }

		  else if(ae.getActionCommand() == "Save")
		     {
		 		 String st = ta.getText();
		 		 if(flg==0)
		 		 {
		 		 		 String tempfname ="Untitled";
		 		 		 tempfname = fname;
		 		 		 FileDialog  fd = new FileDialog(this,"Save",FileDialog.SAVE);
		 		 		 fd.setVisible(true);
		 		 		 fname = fd.getDirectory() + fd.getFile();
		 		 		 efile=fd.getFile();
		 		 		 setTitle(fname + " - Java");
		 		 		 if(fname=="")		 flg=0;
		 		 		 else 		 		 flg=1;
		 		 }

		                if(flg==1)
		 		 {
		 		       try{
		 		 		 FileOutputStream fo = new FileOutputStream(fname);
  		 		 		 int i;
		 		 		 for(i=0;i<st.length();i++)
		 		   		 {
		 		 		 		 fo.write(st.charAt(i));
		 		   		 }
                               		            } catch(IOException ie) {}
		 		 }

		      }

		 else if(ae.getActionCommand() == "Save As...")
		     {
		 		 String st = ta.getText();
		 		 FileDialog  fd = new FileDialog(this,"Save As",FileDialog.SAVE);
		 		 fd.setVisible(true);

		 		 try {
		 		 		 String fname = fd.getDirectory()+fd.getFile();
		 		 		 efile=fd.getFile();
		 		 		 setTitle(fname + " - Java");
		 		 		 FileOutputStream fo = new FileOutputStream(fname);
  		 		 		 int i;
		 		 		 for(i=0;i<st.length();i++)
		 		   		 {
		 		 		 		 fo.write(st.charAt(i));
		 		   		 }
                                     } catch(IOException ie) {}
		     }

		 else if(ae.getActionCommand() == "Exit")
                    {
		 		 System.exit(0);
                    }

		 else if(ae.getActionCommand()=="Cut")
		    {
		 		 editcp = ta.getSelectedText();
		                 String  blk="";
		 		 pos=ta.getCaretPosition();
		 		 int e=pos+editcp.length();
		 		 ta.replaceRange(blk,pos,e);
		    }

		 else if(ae.getActionCommand() == "Copy")
                    {
		 		 editcp=ta.getSelectedText();
		     }

		 else if(ae.getActionCommand() == "Paste")
                    {
		 		 int i;
		 		 i=ta.getCaretPosition();
		 		 ta.insert(editcp,i);
                    }

		 else if(ae.getActionCommand() == "Find...")
                    {
		 		 MyDialog md;
                                md = new MyDialog(this,"Find",4,this,"Find
What :   ");
                    }

		 else if(ae.getActionCommand() == "Replace...")
                    {
		 		 MyDialog md;
                                md = new
MyDialog(this,"Replace",5,this,"Find What :          ");
                    }

		 else if(ae.getActionCommand() == "Go To...")
                    {
		 		 MyDialog md;
                                md = new MyDialog(this,"Goto
Line",2,this,"Line Number :          ");
                    }

		 else if(ae.getActionCommand() == "Select All")
                    {
		 		  ta.select(0,ta.getText().length());
		     }

		 else if(ae.getActionCommand() == "Delete")
                    {
		 		 editcp = ta.getSelectedText();
		                 String  blk="";
		 		 pos=ta.getCaretPosition();
		 		 ta.setCaretPosition(pos);
		 		 int e=pos+editcp.length();
		 		 ta.replaceRange(blk,pos,e);
                    }

		 else if(ae.getActionCommand()=="Compile")
		 {
		 		 Runtime r = Runtime.getRuntime();
		 		 try{
		 		 		 Process p = r.exec("javac " + efile);
		 		     }
		 		  catch ( NullPointerException ee) { }
		 		  catch ( Exception e) {}
		 }

		 else if(ae.getActionCommand()=="Run")
		    {
		 		 StringBuffer sb=new StringBuffer(efile);
		 		 String tstr="";
		 		 int i=0;

		 		 while(sb.charAt(i)!='.')
		 		  {
		 		 		 tstr=tstr+sb.charAt(i);
		 		 		 i++;
		 		  }

		 		 Runtime r = Runtime.getRuntime();
		 		 try{
		 		 		 Process p1 = r.exec("java " + tstr);
		 		     }
		 		  catch ( NullPointerException ee) { }
		 		  catch ( Exception e) {}
 		    }

		 else if(ae.getActionCommand() == "Font...")
                    {
		 		 new FontDlg(this,this);
                    }

		 else if(ae.getActionCommand() == "About...")
		     {
		 		 new About();
		     }

            }

       //////////// Checking Whether The Menu Options Are Checked Or Not
Ends Here ///////////////

		 public static void  main(String str[])
		 {
		 		 new Copyright();
		 		 Editor e = new Editor();
		 }
}
			
