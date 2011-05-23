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


package com.gamecook.matchhack.activities
{
    import com.gamecook.frogue.enum.SlotsEnum;
    import com.gamecook.frogue.equipment.IEquipable;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.MonsterTile;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.factories.SpriteFactory;
    import com.gamecook.matchhack.factories.TextFieldFactory;
    import com.gamecook.matchhack.sounds.MHSoundClasses;
    import com.gamecook.matchhack.utils.ArrayUtil;
    import com.gamecook.matchhack.views.CharacterView;
    import com.gamecook.matchhack.views.StatusBarView;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.threads.effects.Quake;
    import com.jessefreeman.factivity.threads.effects.TypeTextEffect;
    import com.jessefreeman.factivity.utils.DeviceUtil;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import flashx.textLayout.formats.TextAlign;

    import uk.co.soulwire.display.PaperSprite;

    /**
     *
     * This class represents the core logic for the game.
     *
     */
    public class GameActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/game_board.png")]
        private var GameBoardImage:Class;

        [Embed(source="../../../../../build/assets/tile_highlight.png")]
        private var TileHighlightImage:Class;

        private var flipping:Boolean;
        private var activeTiles:Array = [];
        private var maxActiveTiles:int = 1;
        private var tileContainer:Sprite;
        private var tileInstances:Array = [];
        private var player:CharacterView;
        private var monster:CharacterView;
        private var difficulty:int;
        private var statusBar:StatusBarView;
        private var bonus:int = 0;
        private var quakeEffect:Quake;
        private var textEffect:TypeTextEffect;
        private var bonusLabel:TextField;
        private var gameBackground:Bitmap;
        private var highlightInstances:Array = [];
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var debug:Boolean = false;
        private var monsterCounter:int = 0;
        private var monsterAttackDelay:int = 15000;
        private var attackWarningLabel:TextField;

        public function GameActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            // Have the soundManager play the background theme song
            soundManager.playMusic(MHSoundClasses.DungeonLooper);

            super.onCreate();

            // Set the difficulty level from the active state object
            difficulty = activeState.difficulty;
        }

        override public function onStart():void
        {
            super.onStart();


            activeState.initialScore = activeState.score;

            gameBackground = addChild(Bitmap(new GameBoardImage())) as Bitmap;
            gameBackground.x = (fullSizeWidth * .5) - (gameBackground.width * .5);
            gameBackground.y = fullSizeHeight - gameBackground.height;

            tileContainer = addChild(new Sprite()) as Sprite;
            tileContainer.x = gameBackground.x + 55;
            tileContainer.y = gameBackground.y + 50;

            var total:int = 10;
            var i:int;
            var tile:PaperSprite;

            var sprites:Array = SpriteFactory.createSprites(6);

            // Add Potions
            if (int(Math.random() * (difficulty)) == 0)
                sprites.splice(0, 1, "P");

            // Add Gold
            if (int(Math.random() * (difficulty + 2)) == 0)
                sprites.splice(1, 1, "$");

            // Add Treasure
            if (int(Math.random() * (difficulty + 4)) == 0)
                sprites.splice(2, 1, "T");

            var typeIndex:int = -1;
            var typeCount:int = 2;
            var tileBitmap:Bitmap;

            statusBar = addChild(new StatusBarView()) as StatusBarView;
            statusBar.x = (fullSizeWidth - statusBar.width) * .5;
            statusBar.y = logo.y + logo.height;
            var spriteName:String;

            //TODO need to inject player and monster into this array
            for (i = 0; i < total; i++)
            {
                if (i % typeCount == 0)
                    typeIndex ++;

                spriteName = TileTypes.getEquipmentPreview(sprites[typeIndex]) ? TileTypes.getEquipmentPreview(sprites[typeIndex]) : TileTypes.getTileSprite(sprites[typeIndex]);
                tileBitmap = new Bitmap(spriteSheet.getSprite(spriteName));
                tile = tileContainer.addChild(createTile(tileBitmap)) as PaperSprite;
                tileInstances.push(tile);
                tile.name = sprites[typeIndex];

                if (debug)
                    tile.flip();

            }

            activeState.levelTurns = 0;

            createPlayer(total);

            var monsterModel:MonsterTile = new MonsterTile();
            monsterModel.parseObject({name:"monster", maxLife: total / 2});

            monster = tileContainer.addChild(new CharacterView(monsterModel)) as CharacterView;

            monster.generateRandomEquipment();

            attackWarningLabel = monster.addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, "", 20)) as TextField;
            attackWarningLabel.x = -32;
            attackWarningLabel.y = 10;

            var outline:GlowFilter = new GlowFilter();
            outline.blurX = outline.blurY = 2;
            outline.color = 0x000000;
            outline.quality = BitmapFilterQuality.HIGH;
            outline.strength = 100;

            var filterArray:Array = new Array();
            filterArray.push(outline);
            attackWarningLabel.filters = filterArray;

            if (DeviceUtil.os != DeviceUtil.IOS)
                quakeEffect = new Quake(null);
            textEffect = new TypeTextEffect(statusBar.message, onTextEffectUpdate);

            createBonusLabel();

            createHighlights();

            layoutTiles();

            enableLogo();

            updateStatusBar();

            // Update status message
            updateStatusMessage("You have entered level " + activeState.playerLevel + " of the dungeon.");

            // Setup monter timer
            if (difficulty == 1)
            {
                monsterAttackDelay = -1
            }
            else if (difficulty == 2)
            {
                monsterCounter = monsterAttackDelay;
            }
            else
            {
                monsterAttackDelay = monsterAttackDelay * .5;

                if (Math.random() * 1 < .5 && player.getLife() > 1)
                {
                    monsterCounter = monsterAttackDelay;
                }
                else
                {
                    updateStatusMessage("As you enter level " + activeState.playerLevel + " a monster is waiting and attacks you!");
                }

                monsterCounter
            }

        }

        private function createPlayer(total:int):void
        {
            var maxLife:int = (total / difficulty) + 5;

            trace("maxLife", maxLife);

            var playerModel:MonsterTile = new MonsterTile();

            playerModel.parseObject({name:"player", maxLife: maxLife, life:activeState.playerLife > 0 ? activeState.playerLife : maxLife});

            var sprites:Array = [TileTypes.getTileSprite("@")];

            if (activeState.equippedInventory[SlotsEnum.ARMOR])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.ARMOR]));

            if (activeState.equippedInventory[SlotsEnum.HELMET])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.HELMET]));

            if (activeState.equippedInventory[SlotsEnum.BOOTS])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.BOOTS]));

            if (activeState.equippedInventory[SlotsEnum.SHIELD])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.SHIELD]));

            if (activeState.equippedInventory[SlotsEnum.WEAPON])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.WEAPON]));

            player = tileContainer.addChild(new CharacterView(playerModel, sprites)) as CharacterView;
        }

        private function createHighlights():void
        {
            var i:int;
            var tmpHighlight:Bitmap;
            var total:int = maxActiveTiles + 1;
            for (i = 0; i < total; i++)
            {
                tmpHighlight = tileContainer.addChild(new TileHighlightImage()) as Bitmap;
                tmpHighlight.visible = false;
                highlightInstances.push(tmpHighlight);
            }
        }

        private function createBonusLabel():void
        {
            var textFormatLarge:TextFormat = new TextFormat("system", 16, 0xffffff);
            textFormatLarge.align = TextAlign.CENTER;

            bonusLabel = addChild(new TextField()) as TextField;
            bonusLabel.defaultTextFormat = textFormatLarge;
            bonusLabel.text = "Bonus x3";
            bonusLabel.embedFonts = true;
            bonusLabel.selectable = false;
            bonusLabel.autoSize = TextFieldAutoSize.LEFT;
            bonusLabel.background = true;
            bonusLabel.backgroundColor = 0x000000;
            bonusLabel.visible = false;

            bonusLabel.x = (fullSizeWidth - bonusLabel.width) * .5;
            bonusLabel.y = gameBackground.y + gameBackground.height - (bonusLabel.height + 2);
        }

        private function onTextEffectUpdate():void
        {
            //soundManager.play(MHSoundClasses.TypeSound);
        }

        private function updateStatusBar():void
        {
            statusBar.setScore(activeState.score);
            statusBar.setLevel(activeState.playerLevel);
            statusBar.setTurns(activeState.levelTurns);
        }

        /**
         *
         * Goes through the tileInstance array and lays them out in a grid.
         *
         */
        private function layoutTiles():void
        {
            tileInstances = ArrayUtil.shuffleArray(tileInstances);

            tileInstances.splice(4, 0, player);
            tileInstances.splice(7, 0, monster);

            var total:int = tileInstances.length;
            var columns:int = 3;
            var i:int;
            var nextX:int = 0;
            var nextY:int = 0;
            var tile:DisplayObject;

            for (i = 0; i < total; i++)
            {
                tile = tileInstances[i];
                tile.x = nextX;
                tile.y = nextY;

                nextX += 64;
                if (nextX % columns == 0)
                {
                    nextX = 0;
                    nextY += 64;
                }

            }
        }

        /**
         *
         * Creates a new tile with a bitmap on it's back.
         *
         * @param tile - BitmapImage to use for back of tile.
         * @return Instance of the created PaperSprite tile.
         *
         */
        private function createTile(tile:Bitmap):PaperSprite
        {
            // Create Sprite for front
            var front:Sprite = new Sprite();
            front.graphics.beginFill(0x000000, .5);
            front.graphics.drawRect(0, 0, 64, 64);
            front.graphics.endFill();

            // Create TwoSidedPlane
            var tempPlane:PaperSprite = new PaperSprite(front, tile);

            // Make PaperSprite act as a button
            tempPlane.addEventListener(MouseEvent.CLICK, onClick);
            tempPlane.mouseChildren = false;
            tempPlane.buttonMode = true;
            tempPlane.useHandCursor = true;

            return tempPlane;
        }

        /**
         *
         * Handle click event from Tile.
         *
         * @param event
         */
        private function onClick(event:MouseEvent):void
        {
            // Clear status message
            statusBar.setMessage("");

            // Test to see if a tile is flipping
            if (!flipping)
            {
                // Play flip sound
                soundManager.play(MHSoundClasses.WallHit);

                // Get instance of the currently selected PaperSprite
                var target:PaperSprite = event.target as PaperSprite;

                // If this tile is already active exit the method
                if ((activeTiles.indexOf(target) != -1) || player.isDead)
                    return;

                // push the tile into the active tile array
                activeTiles.push(target);

                var highlight:Bitmap = highlightInstances[activeTiles.length - 1];
                highlight.visible = true;
                highlight.x = target.x - (target.width * .5) + 1;
                highlight.y = target.y - (target.height * .5) + 1;

                // Check if the debug mode is on, we need to do handle this differently.
                if (!debug)
                {

                    // We are about to flip the tile. Add a complete event listener so we know when it's done.
                    target.addEventListener(Event.COMPLETE, onFlipComplete);

                    // Flip the tile
                    target.flip();

                    // Set the flipping flag.
                    flipping = true;
                }
                else
                {
                    // If difficulty was set to 1 (easy) there is no flip so manually call endTurn.
                    endTurn();
                }

            }

        }

        /**
         *
         * Called when a tile's Flip is completed.
         *
         * @param event
         *
         */
        private function onFlipComplete(event:Event):void
        {

            // Get the tile that recently flipped
            var target:PaperSprite = event.target as PaperSprite;

            // Remove the event listener
            target.removeEventListener(Event.COMPLETE, onFlipComplete);

            // Set the flipping flag to false
            flipping = false;

            // End the turn.
            endTurn();
        }

        /**
         *
         * This validates if we have reached the total number of active tiles. If so we need to check for matches and
         * handle any related game logic.
         *
         */
        private function endTurn():void
        {

            // See if we have active the maximum active tiles allowed.
            if (activeTiles.length > maxActiveTiles)
            {
                // Validate any matches
                findMatches();

                // Reset any tiles that do not match
                resetActiveTiles();

                // Increment our turns counter in the activeState object
                activeState.levelTurns ++;
                activeState.increaseTotalTurns();
            }

        }

        /**
         *
         * This method goes through all of the Active tiles and tries to identify any matches.
         *
         */
        private function findMatches():void
        {

            var i:int, j:int;
            var total:int = activeTiles.length;
            var currentTile:PaperSprite;
            var testTile:PaperSprite;
            var tileName:String;
            var match:Boolean;

            // Loop through active tiles and compare each item to the rest of the tiles in the array.
            for (i = 0; i < total; i++)
            {
                // save an instance of the current tile to test with
                currentTile = activeTiles[i];
                tileName = currentTile.name;
                // Reloop through all the items starting back at the beginning
                for (j = 0; j < total; j++)
                {
                    // select the item to test against
                    testTile = activeTiles[j];
                    // Make sure we aren't testing the same item
                    if ((currentTile != testTile) && (currentTile.name == testTile.name))
                    {
                        // A match has been found so make sure the current tile and test tile are set to invisible.
                        currentTile.visible = false;
                        testTile.visible = false;

                        // Flag that a match has been found.
                        match = true;

                    }
                }

                if (highlightInstances[i])
                    highlightInstances[i].visible = false;
            }

            // Validate match
            if (match)
            {
                onMatch(tileName);
            }
            else
            {
                // Update status message
                updateStatusMessage("You did not find a match.\nYou lose 1 HP from the monster's attack.");
                onNoMatch();
            }

        }

        /**
         *
         * Loops through any active tiles and flips them. This only calls flip for any difficulty level higher then 1 (easy)
         *
         */
        private function resetActiveTiles():void
        {
            // Loop through all tiles
            for each (var tile:PaperSprite in activeTiles)
            {
                // Make sure the difficulty is higher then easy
                if (!debug)
                    tile.flip();
            }

            // Clear the activeTiles array when we are done.
            activeTiles.length = 0;
        }

        /**
         *
         * Called when no match is found.
         *
         */
        private function onNoMatch():void
        {
            if (quakeEffect)
            {
                quakeEffect.target = player;
                addThread(quakeEffect);
            }

            // Reset bonus flag
            resetBonus();

            // Take away 1 HP from the player
            player.subtractLife(1);

            // Play attack sound
            soundManager.play(MHSoundClasses.EnemyAttack);

            // Update status before testing if the player is dead
            updateStatusBar();

            // Reset monster attack counter
            monsterCounter = monsterAttackDelay;

            // Test to see if the player is dead
            if (player.isDead)
                onPlayerDead();
        }

        private function resetBonus():void
        {
            bonus = 0;
            bonusLabel.visible = false;
        }

        /**
         *
         * Called when a match is found.
         *
         */
        private function onMatch(type:String):void
        {
            trace("Matched", type, type.substr(0, 1));

            switch (type.substr(0, 1))
            {
                case "P":
                    updateStatusMessage("Player drinks potion and restores " + (player.getMaxLife() - player.getLife()));
                    trace("Found Potion");
                    player.addLife(player.getMaxLife());
                    increaseBonus();
                    break

                case "W":
                    trace("Found Weapon");
                    //playerAttack();
                    break;

                case "S":
                case "H":
                case "A":
                case "B":
                    trace("Found Armor");
                    //playerAttack();
                    break;

                case "$":
                    trace("Found Money");

                    increaseBonus();
                    break;

                case "T":
                    trace("Found Treasure");
                    increaseBonus();
                    break;


            }

            playerAttack();

            // Reset monster attack counter
            monsterCounter = monsterAttackDelay;
        }

        private function playerAttack():void
        {
            if (quakeEffect)
            {
                quakeEffect.target = monster;
                addThread(quakeEffect);
            }

            // Increase bonus flag
            increaseBonus();

            // Take away 1 HP from the monster
            monster.subtractLife(1);

            // Play attack sound
            soundManager.play(MHSoundClasses.PotionSound);

            // Update status message
            updateStatusMessage("You have found a match!\nThe monster loses 1 HP from your attack.");

            activeState.score += 1 + bonus;

            // Update status before testing for monster being dead
            updateStatusBar();

            // Test to see if the monster is dead
            if (monster.isDead)
                onMonsterDead();
        }

        private function displayBonusMessage(value:String):void
        {
            bonusLabel.text = value;
            bonusLabel.x = (fullSizeWidth - bonusLabel.width) * .5;

            if (bonus > 0)
                bonusLabel.visible = true;
        }

        private function increaseBonus():void
        {
            bonus ++;
            activeState.bestBonus = bonus;

            if (bonus > 0)
                displayBonusMessage("Bonus x" + bonus);
        }

        /**
         *
         * Called when the player is dead.
         *
         */
        private function onPlayerDead():void
        {
            if (quakeEffect)
            {
                removeThread(quakeEffect)
            }

            // Update status message
            updateStatusMessage("You have been defeated!");

            // Flip over the player's tile to show the blood
            player.flip();

            // Kill all sounds, including the BG music.
            soundManager.destroySounds(true);

            // Play death sound
            soundManager.play(MHSoundClasses.DeathTheme);

            // Clear the activeGame so player can't exit and try again.
            activeState.activeGame = false;

            // Show the game over activity after 2 seconds
            startNextActivityTimer(LoseActivity, 2, {characterImage: monster.getImage()});
        }

        /**
         *
         * Called when the monster is dead.
         *
         */
        private function onMonsterDead():void
        {
            if (quakeEffect)
            {
                removeThread(quakeEffect)
            }

            //Save State
            activeState.playerLife = player.getLife();

            // Update status message
            updateStatusMessage("You have defeated the monster.");

            // Flip over the monster's tile to show the blood.
            monster.flip();

            // Kill all sounds, including the BG music.
            soundManager.destroySounds(true);

            // Play win sound
            soundManager.play(MHSoundClasses.WinBattle);

            var equipment:IEquipable;
            var rand:int = Math.random() * 6;

            var droppedEquipment:IEquipable

            switch (rand)
            {
                case SlotsEnum.ARMOR:
                    droppedEquipment = monster.getArmorSlot();
                    break;
                case SlotsEnum.WEAPON:
                    droppedEquipment = monster.getWeaponSlot();
                    break;
                case SlotsEnum.SHIELD:
                    droppedEquipment = monster.getShieldSlot();
                    break;
                case SlotsEnum.HELMET:
                    droppedEquipment = monster.getHelmetSlot();
                    break;
                case SlotsEnum.BOOTS:
                    droppedEquipment = monster.getHelmetSlot();
                    break;
            }

            // Show the game over activity after 2 seconds
            startNextActivityTimer(WinActivity, 2, {characterImage: player.getImage(), droppedEquipment: droppedEquipment});
        }

        public function updateStatusMessage(value:String):void
        {
            if (value.length > 0)
            {
                if (textEffect)
                {
                    textEffect.newMessage(value, 2);
                    addThread(textEffect);
                    value = "";
                }
                else
                {
                    statusBar.message.text = value;
                }
            }
            else
            {
                statusBar.message.text = value;
            }
        }


        override public function onBack():void
        {
            super.onBack();
            nextActivity(StartActivity);
        }

        override public function update(elapsed:Number = 0):void
        {

            super.update(elapsed);

            if (monsterAttackDelay != -1)
            {
                if (monsterCounter <= 0)
                    onNoMatch();
                else
                {
                    monsterCounter -= elapsed;
                    if (monsterCounter <= 5500)
                    {
                        var timeLeft:int = Math.round(monsterCounter / 1000)

                        if (timeLeft < 4)
                        {
                            attackWarningLabel.textColor = 0xff0000;
                        }
                        else
                        {
                            attackWarningLabel.textColor = 0xffffff;
                        }

                        attackWarningLabel.text = timeLeft == 0 ? "!!" : timeLeft.toString();
                    }
                    else
                    {
                        attackWarningLabel.text = "";
                    }
                }
            }
        }

    }
}
