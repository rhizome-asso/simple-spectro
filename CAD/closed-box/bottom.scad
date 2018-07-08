use <screwHole.scad>;
use <roundedParallelepiped4.scad>;

module bottom(
    batteryHeight, batteryLength, batteryWidth, batteryX, batteryY,
    bottomClosureSpace, bottomDigged, bottomHeight, bottomSmallHoleR, bottomHoleR,
    bottomHoleExternalHeight, bottomHoleInternalHeight, bottomMinimal,
    connectorHeight, connectorLength, connectorWidth, connectorX, connectorY,
    cuvetteBottomSpace, cuvetteX, cuvetteY, cuvetteInternal, frontHeight,
    overlap, pcbLength, pcbSpaceAround, pcbWidth, radius, shift, sideThickness, supportHoleX, supportHoleY, usbSpace, usbSpaceThickness, usbWidth, usbY) {
        
    
    // create the bottom part 
    translate([0, 0, frontHeight])
        union() {
            difference() {
                
                    // the bottom
                cube([
                    pcbLength+2*pcbSpaceAround+2*sideThickness,
                    pcbWidth+2*pcbSpaceAround+2*sideThickness,
                    bottomHeight
                ]);
                
                // remove the external border so it fits in the other part
                difference() {
                    cube([
                        pcbLength+2*pcbSpaceAround+2*sideThickness,
                        pcbWidth+2*pcbSpaceAround+2*sideThickness,
                        overlap
                    ]);
                    translate([sideThickness/2+bottomClosureSpace, sideThickness/2+bottomClosureSpace, 0])
                        roundedParallelepiped4(
                            x=pcbLength+2*pcbSpaceAround+sideThickness-2*bottomClosureSpace,
                            y=pcbWidth+2*pcbSpaceAround+sideThickness-2*bottomClosureSpace,
                            z=overlap,
                            r=radius
                        );
                }
                
                // remove some volume to have room for pcb
                translate([sideThickness, sideThickness, 0])
                    roundedParallelepiped4(
                        x=pcbLength+2*pcbSpaceAround,
                        y=pcbWidth+2*pcbSpaceAround,
                        z=bottomDigged,
                        r=radius
                    );
                
                // remove the hole for cuvette
                translate([
                    cuvetteX-cuvetteBottomSpace,
                    cuvetteY-cuvetteBottomSpace,
                    0
                ])
                roundedParallelepiped4(x=cuvetteInternal+2*cuvetteBottomSpace, y=cuvetteInternal+2*cuvetteBottomSpace, z=bottomHeight-bottomMinimal, r=radius);
                
                  // remove the hole for battery
                translate([
                    batteryX,
                    batteryY,
                    bottomDigged
                ])
                    roundedParallelepiped4(x=batteryLength, y=batteryWidth, z=batteryHeight, r=radius);
                 
                 // the hole for the barrery connector
                 translate([
                    connectorX,
                    connectorY,
                    bottomDigged
                ])
                    roundedParallelepiped4(x=connectorLength, y=connectorWidth, z=connectorHeight, r=radius);
                    
                // small line for battery cable
                translate([
                    connectorX + connectorLength - radius,
                    connectorY,
                    bottomDigged
                ])
                    cube([batteryX-connectorX-connectorWidth + 2 * radius, batteryY + batteryWidth - connectorY, batteryHeight]);
                
                // we remove cutting edges
                translate([
                    batteryX-radius,
                    connectorY-radius,
                    bottomDigged
                ])
                    difference() {
                        cube([radius, radius, batteryHeight]);
                        cylinder(h=batteryHeight, r=radius);
                    };
                
                translate([
                    connectorX + connectorLength + radius,
                    batteryY + batteryWidth+radius-0.001,
                    bottomDigged
                ])
                    difference() {
                        translate([-radius, -radius, 0]) 
                            cube([radius, radius, batteryHeight]);
                        cylinder(h=batteryHeight, r=radius);
                    };
             
                
                
                  // we remove the USB port
                translate([0,usbY,0])
                    cube([sideThickness,usbWidth,overlap]);
                // remove some more space so the USB plug fits in
                translate([-usbSpaceThickness,usbY-usbSpace,0])
                    roundedParallelepiped4(
                        x=usbSpaceThickness*2,
                        y=usbWidth+2*usbSpace,
                        z=overlap+usbSpace,
                        r=1
                    );
                
                // make holes for screws        
                translate([shift+supportHoleX, shift+supportHoleY, 0])
                    screwHole(rSmall=bottomSmallHoleR, rLarge=bottomHoleR, height=bottomHeight, heightExternal=bottomHoleExternalHeight, heightInternal=bottomHoleInternalHeight);
                
                translate([shift+pcbLength-supportHoleX, shift+supportHoleY, 0])
                    screwHole(rSmall=bottomSmallHoleR, rLarge=bottomHoleR, height=bottomHeight, heightExternal=bottomHoleExternalHeight, heightInternal=bottomHoleInternalHeight);
                
                translate([shift+supportHoleX, shift+pcbWidth-supportHoleY, 0])
                    screwHole(rSmall=bottomSmallHoleR, rLarge=bottomHoleR, height=bottomHeight, heightExternal=bottomHoleExternalHeight, heightInternal=bottomHoleInternalHeight);
                
                translate([shift+pcbLength-supportHoleX, shift+pcbWidth-supportHoleY, 0])
                    screwHole(rSmall=bottomSmallHoleR, rLarge=bottomHoleR, height=bottomHeight, heightExternal=bottomHoleExternalHeight, heightInternal=bottomHoleInternalHeight);     
            };
            
            /* little border around the cell
            translate([
                cuvetteX-cuvetteBottomSpace-cuvetteThickness,
                cuvetteY-cuvetteBottomSpace-cuvetteThickness,
                overlap
            ])
                difference() {
                    cube([
                        cuvetteInternal+2*cuvetteBottomSpace+2*cuvetteThickness,
                        cuvetteInternal+2*cuvetteBottomSpace+2*cuvetteThickness,
                        bottomHeight-bottomMinimal-overlap
                    ]);
                 // remove the hole for cuvette
                    translate([
                        cuvetteThickness,
                        cuvetteThickness,
                        0
                    ])
                    roundedParallelepiped4(x=cuvetteInternal+2*cuvetteBottomSpace, y=cuvetteInternal+2*cuvetteBottomSpace, z=bottomHeight-bottomMinimal, r=radius);
                }
            */ 
            
    };
}