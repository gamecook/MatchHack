/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package
{
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.activities.InventoryActivity;
    import com.gamecook.matchhack.activities.SplashActivity;
    import com.gamecook.matchhack.analytics.GoogleTracker;
    import com.jessefreeman.factivity.AbstractApplication;
    import com.jessefreeman.factivity.activities.ActivityManager;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.analytics.ITrack;
    import com.jessefreeman.factivity.utils.DeviceUtil;

    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    [SWF(width="480",height="700",backgroundColor="#000000",frameRate="60")]
    public class MatchHack extends AbstractApplication
    {

        private var tracker:ITrack;
        private var scale:Number = 1;

        /*
         You will need to create a class called analytics.as with the following in it:

         private var key:String = "UA-xxxxxxxx-x";

         */
        include "analytics.as";

        public function MatchHack()
        {
            // Automatically figures out the scale based on stage's height. Used to scale up on each device.
            scale = DeviceUtil.getScreenHeight(stage) / 400;

            // Google Analytics Tracker
            tracker = new GoogleTracker(this, key, "AS3", false);

            // Configures the stage
            configureStage();

            // Passes up a custom ActivityManager to super along with the start activity and scale.
            //super(new ActivityManager(tracker), InventoryActivity, 0, 0, scale);
            super(new ActivityManager(tracker), SplashActivity, 0, 0, scale);
            //super(new ActivityManager(tracker), LoadingActivity, 0, 0, scale);

            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function configureStage():void
        {
            // Setup stage align and scale mode.
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.quality = StageQuality.LOW;
            // Set up the screen size for BaseActivity
            BaseActivity.fullSizeWidth = DeviceUtil.getScreenWidth(stage) / scale;
            BaseActivity.fullSizeHeight = DeviceUtil.getScreenHeight(stage) / scale;
        }

        override protected function init():void
        {
            TileTypes.registerTile('F1', { name: 'Floor1', sprite: "sprite0"});
            TileTypes.registerTile('F2', { name: 'Floor2', sprite: "sprite1"});
            TileTypes.registerTile('F3', { name: 'Floor3', sprite: "sprite"});
            TileTypes.registerTile('F4', { name: 'Floor4', sprite: "sprite3"});
            TileTypes.registerTile('F5', { name: 'Floor5', sprite: "sprite4"});
            TileTypes.registerTile('F6', { name: 'Floor6', sprite: "sprite5"});
            TileTypes.registerTile('F7', { name: 'Floor7', sprite: "sprite6"});
            TileTypes.registerTile('F8', { name: 'Floor8', sprite: "sprite7"});

            TileTypes.registerTile('#', { name: 'Wall', sprite: "sprite8"});

            TileTypes.registerTile('E', { name: 'Exit', sprite: "sprite9"});

            TileTypes.registerTile('C1', { name: 'Bronze Coin', sprite: "sprite10"});
            TileTypes.registerTile('C2', { name: 'Silver Coin', sprite: "sprite11"});
            TileTypes.registerTile('C3', { name: 'Gold Coin', sprite: "sprite12"});

            TileTypes.registerTile('T', { name: 'Treasure Chest', sprite: "sprite13"});

            TileTypes.registerTile('$', { name: 'Gold', sprite: "sprite14"});
            TileTypes.registerTile('P', { name: 'Potion', sprite: "sprite15"});
            TileTypes.registerTile('X1', { name: 'Blood 1', sprite: "sprite16"});
            TileTypes.registerTile('X2', { name: 'Blood 2', sprite: "sprite17"});
            TileTypes.registerTile('X3', { name: 'Blood 3', sprite: "sprite18"});

            TileTypes.registerTile('@', { name: 'Player', sprite: "sprite19"});
            TileTypes.registerTile('M1', { name: 'Ork', sprite: "sprite20"});
            TileTypes.registerTile('M2', { name: 'Oger', sprite: "sprite21"});
            TileTypes.registerTile('M3', { name: 'Goblin', sprite: "sprite22"});
            TileTypes.registerTile('M4', { name: 'Wolfman', sprite: "sprite23"});
            TileTypes.registerTile('M5', { name: 'Vampire', sprite: "sprite24"});
            TileTypes.registerTile('M6', { name: 'Mummy', sprite: "sprite25"});
            TileTypes.registerTile('M7', { name: 'Skeleton', sprite: "sprite26"});
            TileTypes.registerTile('M8', { name: 'Imp', sprite: "sprite27"});
            TileTypes.registerTile('M9', { name: 'Gargoyle', sprite: "sprite28"});

            /* Weapons */
            TileTypes.registerTile('W1', { name: 'Trident', sprite: "sprite29", preview:"sprite30"});
            TileTypes.registerTile('W2', { name: 'Sai', sprite: "sprite31", preview:"sprite32"});
            TileTypes.registerTile('W3', { name: 'Compound Bow', sprite: "sprite33", preview:"sprite34"});
            TileTypes.registerTile('W4', { name: 'Long Bow', sprite: "sprite35", preview:"sprite36"});
            TileTypes.registerTile('W5', { name: 'Bow', sprite: "sprite37", preview:"sprite38"});
            TileTypes.registerTile('W6', { name: 'Wide Sword', sprite: "sprite39", preview:"sprite40"});
            /*TileTypes.registerTile('W7', { name: 'Crop', sprite: "sprite41", preview:"sprite42"});
            TileTypes.registerTile('W8', { name: 'Flogger', sprite: "sprite43", preview:"sprite44"});*/
            TileTypes.registerTile('W9', { name: 'Small Knife', sprite: "sprite45", preview:"sprite46"});
            TileTypes.registerTile('W10', { name: 'Throwing Axe', sprite: "sprite47", preview:"sprite48"});
            TileTypes.registerTile('W11', { name: 'Hammer', sprite: "sprite49", preview:"sprite50"});
            TileTypes.registerTile('W12', { name: 'Curved Sword', sprite: "sprite51", preview:"sprite52"});
            TileTypes.registerTile('W13', { name: 'Xena Sword', sprite: "sprite53", preview:"sprite54"});
            TileTypes.registerTile('W14', { name: 'Spear', sprite: "sprite55", preview:"sprite56"});
            TileTypes.registerTile('W15', { name: 'cane', sprite: "sprite57", preview:"sprite58"});
            TileTypes.registerTile('W16', { name: 'Magic Wand', sprite: "sprite59", preview:"sprite60"});
            TileTypes.registerTile('W17', { name: 'Lead Pipe', sprite: "sprite61", preview:"sprite62"});
            TileTypes.registerTile('W18', { name: 'Knuckles', sprite: "sprite63", preview:"sprite64"});
            TileTypes.registerTile('W19', { name: 'Dagger', sprite: "sprite65", preview:"sprite66"});
            TileTypes.registerTile('W20', { name: 'Foil', sprite: "sprite67", preview:"sprite68"});
            TileTypes.registerTile('W21', { name: 'Sword', sprite: "sprite69", preview:"sprite70"});
            TileTypes.registerTile('W22', { name: 'Mace', sprite: "sprite71", preview:"sprite72"});
            TileTypes.registerTile('W23', { name: 'Axe', sprite: "sprite73", preview:"sprite74"});
            TileTypes.registerTile('W24', { name: 'Croquet Mallot', sprite: "sprite75", preview:"sprite76"});
            TileTypes.registerTile('W25', { name: 'Whip', sprite: "sprite77", preview:"sprite78"});
            TileTypes.registerTile('W26', { name: 'Club', sprite: "sprite79", preview:"sprite80"});
            TileTypes.registerTile('W27', { name: 'Stick', sprite: "sprite81", preview:"sprite82"});

            TileTypes.registerTile('S1', { name: 'Oval Shield', sprite: "sprite83", preview:"sprite84"});
            TileTypes.registerTile('S2', { name: 'Warrior Shield', sprite: "sprite85", preview:"sprite86"});
            TileTypes.registerTile('S3', { name: 'Round X Shield', sprite: "sprite87", preview:"sprite88"});
            TileTypes.registerTile('S4', { name: 'American Shield', sprite: "sprite89", preview:"sprite90"});
            TileTypes.registerTile('S5', { name: 'Long Shield', sprite: "sprite91", preview:"sprite92"});
            TileTypes.registerTile('S6', { name: 'Scaloped Shield', sprite: "sprite93", preview:"sprite94"});
            TileTypes.registerTile('S7', { name: 'Round Shield', sprite: "sprite95", preview:"sprite96"});

            TileTypes.registerTile('H1', { name: 'Baseball Hat', sprite: "sprite97", preview:"sprite98"});
            TileTypes.registerTile('H2', { name: 'Secret Mask', sprite: "sprite99", preview:"sprite100"});
            /*TileTypes.registerTile('H3', { name: 'Storm Trooper Helmet', sprite: "sprite101", preview:"sprite102"});
            TileTypes.registerTile('H4', { name: 'Gimp Mask', sprite: "sprite103", preview:"sprite104"});*/
            TileTypes.registerTile('H5', { name: 'Bucket Helmet', sprite: "sprite105", preview:"sprite106"});
            TileTypes.registerTile('H6', { name: 'Open Helmet', sprite: "sprite107", preview:"sprite108"});
            TileTypes.registerTile('H7', { name: 'Fuller', sprite: "sprite109", preview:"sprite110"});
            TileTypes.registerTile('H8', { name: 'Short Helmet', sprite: "sprite111", preview:"sprite112"});
            TileTypes.registerTile('H9', { name: 'Full Helmet', sprite: "sprite113", preview:"sprite114"});
            TileTypes.registerTile('H10', { name: 'Roman Helmet', sprite: "sprite115", preview:"sprite116"});

            TileTypes.registerTile('A1', { name: 'Full Armor', sprite: "sprite117", preview:"sprite118"});
            TileTypes.registerTile('A2', { name: 'Metal Bikini', sprite: "sprite119", preview:"sprite120"});
            TileTypes.registerTile('A3', { name: 'Chain Shorts', sprite: "sprite121", preview:"sprite122"});
            TileTypes.registerTile('A4', { name: 'Light Chainmail', sprite: "sprite123", preview:"sprite124"});
            TileTypes.registerTile('A5', { name: 'Chainmail', sprite: "sprite125", preview:"sprite126"});
            TileTypes.registerTile('A6', { name: 'T shirt', sprite: "sprite127", preview:"sprite128"});
            TileTypes.registerTile('A7', { name: 'Chest Armor', sprite: "sprite129", preview:"sprite130"});
            TileTypes.registerTile('A8', { name: 'Brown Robe', sprite: "sprite131", preview:"sprite132"});
            TileTypes.registerTile('A9', { name: 'Blue Robe', sprite: "sprite133", preview:"sprite134"});
            TileTypes.registerTile('A10', { name: 'Red Robe', sprite: "sprite135", preview:"sprite136"});

            TileTypes.registerTile('B1', { name: 'Pointy Boots', sprite: "sprite137", preview:"sprite138"});
            TileTypes.registerTile('B2', { name: 'Square Boots', sprite: "sprite139", preview:"sprite140"});
            TileTypes.registerTile('B3', { name: 'Simple Boots', sprite: "sprite141", preview:"sprite142"});



            super.init();
        }

        private function onKeyDown(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.ESCAPE)
            {
                event.preventDefault();
                activityManager.back();
            }
        }

    }
}
