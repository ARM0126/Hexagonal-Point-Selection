
Imagename = File.openDialog("Open an Image to analyze");
if (Imagename=="")
	exit();
write("Image name = "+Imagename);
open(Imagename);
getPixelSize(unit, pw, ph, pd);
if ( unit=="" || unit==" " || unit=="pixels" ) {
	unit = "pixels";
	print("To calibrate units: open a calibration image, draw a line along a known distance, choose Analyze/Set Scale");
}

keep_going = true;

while (keep_going)
{


//-- Collect three points
setTool("multipoint");
waitForUser("Select three points on the circle radius and hit OK");

getSelectionCoordinates(x, y);

run("Add Selection...");

run("Select None");
if (x.length != 3){
	exit("Calculation requires only three points");
}


//-- First calculate the perimeter of the triangle
d1=sqrt((x[0]-x[1])*(x[0]-x[1])+(y[0]-y[1])*(y[0]-y[1]));
d2=sqrt((x[1]-x[2])*(x[1]-x[2])+(y[1]-y[2])*(y[1]-y[2]));
d3=sqrt((x[2]-x[0])*(x[2]-x[0])+(y[2]-y[0])*(y[2]-y[0]));

//numirator

//F=2*(d2*d3);

F=-pow(d1,2)+pow(d2,2)+pow(d3,2);
G=2*d2*d3;
zawia=acos(F/G);
indeg=(zawia/3.14159265359)*180; //returns r2 in degree
//G=(-(d1*d1)+d2*d2+d3*d3);

//v1=-pow(d1,2);

//v2=d2*d2;

//v3=d3*d3;

//p2=v1+v2+v3/F;


//r1=acos(-d1^2+d2^2+d3^2/2*d2*d3);

//-- Half the perimeter
s=0.5*(d1+d2+d3);
//-- Area of circumcircle
a=sqrt(s*(s-d1)*(s-d2)*(s*d3));
//-- Circumradius
r=(d1*d2*d3)/sqrt((d1+d2+d3)*(d2+d3-d1)*(d3+d1-d2)*(d1+d2-d3));
//-- Menger curvature is the inverse of the radius of the circle
mc=1/r;

//-- Centroid coordinates (from https://en.wikipedia.org/wiki/Circumscribed_circle#Cartesian_coordinates_2)
D=2*abs(x[0]*(y[1]-y[2]) + x[1]*(y[2]-y[0]) + x[2]*(y[0]-y[1]));

cenX=abs((x[0]*x[0]+y[0]*y[0]) * (y[1]-y[2]) + (x[1]*x[1]+y[1]*y[1]) * (y[2]-y[0]) + (x[2]*x[2]+y[2]*y[2]) * (y[0]-y[1]))/D;
cenY=abs((x[0]*x[0]+y[0]*y[0]) * (x[2]-x[1]) + (x[1]*x[1]+y[1]*y[1]) * (x[0]-x[2]) + (x[2]*x[2]+y[2]*y[2]) * (x[1]-x[0]))/D;

//-- report
print("a: "+x[0]+","+y[0]);
print("b: "+x[1]+","+y[1]);
print("c: "+x[2]+","+y[2]);
print("Area of circumcircle: "+a);
print("Radius: "+r);
print("Menger Curvature: "+mc);
print("Circumcentre: "+cenX+","+cenY);
print("angle in radians: " +zawia);
print("angle in degree: " +indeg);
print("F: " +F);
print("G: " +G);
//print("d3d3: " +v3);

//-- Create an overlay

//-- Triangle
makePolygon(x[0],y[0],x[1],y[1],x[2],y[2]);
Overlay.addSelection("cyan");

//-- Circumcentre
makeLine(cenX-5,cenY,cenX+5,cenY);
//Overlay.addSelection("magenta");
makeLine(cenX,cenY-5,cenX,cenY+5);
//Overlay.addSelection("magenta");

//-- Circumcircle
run("Specify...", "width="+(r*2)+" height="+(r*2)+" x="+cenX+" y="+cenY+" oval centered");
//Overlay.addSelection("blue");

run("Select None");

// write output to file (got from analyze stripes)
shortimagename = File.nameWithoutExtension;
logfile = File.directory+File.separator+"Hexatic3_log.txt";
if (!File.exists(logfile))
	File.append("image name \tx1 \ty1 \tx2 \ty2 \tx3 \ty3 \tdistance(d1) \tdistance(d2) \tdistance(d3) \tAngle  \tAngle (in Degrees)",logfile);
//File.append(shortimagename+" \t"+zawia+" \t"+F+" \t"+G+" \t"+r,logfile);
File.append(shortimagename+" \t"+x[0]+" \t"+y[0]+" \t"+x[1]+" \t"+y[1]+" \t"+x[2]+" \t"+y[2]+" \t"+d1+" \t"+d2+" \t"+d3+" \t"+zawia+" \t"+indeg,logfile);
//File.close(logfile);	// file will close automatically when macro exits
//File.append("image name \td1 \td2 \td3 \tzawia \tRMS edge roughness (Rq) \tpeak-to-peak edge roughness (Rt) \tunits",logfile);

	// Dialog to decide whether to keep going or not
	Dialog.create("Instructions");
	Dialog.addCheckbox("Keep going?", true);	
	Dialog.show();
	keep_going = Dialog.getCheckbox;
	waitForUser;
	
}	
print("I stopped")


