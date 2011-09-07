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

package com.gamecook.matchhack.views
{
    import com.gamecook.frogue.combat.ICombatant;
    import com.gamecook.frogue.enum.SlotsEnum;
    import com.gamecook.frogue.equipment.IEquipable;
    import com.gamecook.frogue.factories.EquipmentFactory;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.IMonster;
    import com.gamecook.frogue.tiles.MonsterTile;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.utils.ArrayUtil;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;

    import uk.co.soulwire.display.PaperSprite;

    public class CharacterView extends PaperSprite implements IMonster
    {
        include "types.as"
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var lifeBar:LifeBarView;
        private const PLAYER:String = "player";
        private var characterImage:Bitmap;
        private var container:Sprite;
        private var bloodImage:Bitmap;
        private var model:MonsterTile;
        private var baseSpriteID:String;
        private var overrideSprites:Array;
        private var _equipmentIDs:Array = [];

        public function CharacterView(model:MonsterTile, overrideSprites:Array = null)
        {
            this.model = model;
            this.overrideSprites = overrideSprites;
            this.name = model.getName();

            container = new Sprite();

            lifeBar = container.addChild(new LifeBarView(model.getLife(), model.getMaxLife())) as LifeBarView;
            lifeBar.x = -2;
            lifeBar.y = 2;

            lifeBar.x += (64 - lifeBar.width);
            container.x -= 32;
            container.y -= 32;

            if (name == PLAYER)
            {
                baseSpriteID = "@";
            }
            else
            {
                var monsters:Array = ["M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9"];
                baseSpriteID = ArrayUtil.pickRandomArrayElement(monsters)
            }
            //Cleanup sprite name
            baseSpriteID = TileTypes.getTileSprite(baseSpriteID);

            createImage();

            bloodImage = new Bitmap(spriteSheet.getSprite(TileTypes.getTileSprite(ArrayUtil.pickRandomArrayElement(["X1", "X2", "X3"]))));

            super(container, bloodImage);
        }

        public function generateRandomEquipment():void
        {
            var weaponGenerator:EquipmentFactory = new EquipmentFactory(spriteSheet, types);
            var equipmentTypes:Array = [SlotsEnum.WEAPON, SlotsEnum.ARMOR, SlotsEnum.HELMET, SlotsEnum.SHIELD, SlotsEnum.BOOTS];

            var total:int = Math.random() * equipmentTypes.length;
            var i:int = 0;
            var tmpEquipment:IEquipable;

            for (i = 0; i < total; i++)
            {
                tmpEquipment = weaponGenerator.createEquipment(1, equipmentTypes[i]);
                if (tmpEquipment)
                {
                    IMonster(model).equip(tmpEquipment);
                    _equipmentIDs.push(tmpEquipment.tileID);
                }
            }

            createImage();
        }

        private function createImage():void
        {

            if (model.getSpriteID() != "")
                baseSpriteID = baseSpriteID.concat("," + model.getSpriteID());

            var bitmapData:BitmapData = spriteSheet.getSprite.apply(this, overrideSprites ? overrideSprites : baseSpriteID.split(","));
            characterImage = container.addChild(new Bitmap(bitmapData)) as Bitmap;
            characterImage.x -= 2;
        }

        public function getImage():Bitmap
        {
            return characterImage;
        }

        public function getHitValue():int
        {
            return model.getHitValue();
        }

        public function getDefenseValue():int
        {
            return model.getDefenseValue();
        }

        public function getMaxLife():int
        {
            return model.getMaxLife();
        }

        public function addMaxLife(value:int):void
        {
            model.addMaxLife(value);
        }

        public function attack(monster:ICombatant, useChance:Boolean):void
        {
            model.attack(monster, useChance);
        }

        public function defend(monster:ICombatant):void
        {
            model.defend(monster);
        }

        public function get isDead():Boolean
        {
            return model.isDead;
        }

        public function getName():String
        {
            return model.getName();
        }

        public function get id():String
        {
            return model.id;
        }

        public function get type():String
        {
            return model.type;
        }

        public function setWeaponSlot(value:IEquipable):void
        {
            model.setWeaponSlot(value);
        }

        public function getWeaponSlot():IEquipable
        {
            return model.getWeaponSlot();
        }

        public function setHelmetSlot(value:IEquipable):void
        {
            model.setHelmetSlot(value);
        }

        public function getHelmetSlot():IEquipable
        {
            return model.getHelmetSlot();
        }

        public function setArmorSlot(value:IEquipable):void
        {
            model.setArmorSlot(value);
        }

        public function getArmorSlot():IEquipable
        {
            return model.getArmorSlot();
        }

        public function setShieldSlot(value:IEquipable):void
        {
            model.setShieldSlot(value);
        }

        public function getShieldSlot():IEquipable
        {
            return model.getShieldSlot();
        }

        public function setShoeSlot(value:IEquipable):void
        {
            model.setShoeSlot(value);
        }

        public function getShoeSlot():IEquipable
        {
            return model.getShoeSlot();
        }

        public function equip(item:IEquipable):IEquipable
        {
            return model.equip(item);
        }

        public function canEquip(item:IEquipable):Boolean
        {
            return model.canEquip(item);
        }

        public function getLife():int
        {
            return model.getLife();
        }

        public function subtractLife(value:int):void
        {
            model.subtractLife(value);
            lifeBar.setTotal(model.getLife());
        }

        public function addLife(value:int):void
        {
            model.addLife(value);
            lifeBar.setTotal(model.getLife());
        }

        /* Not used */
        public function setAttackRolls(value:int):void
        {
        }

        public function setDefenseRolls(value:int):void
        {
        }


        public function addAttackRoll(i:int):void
        {
        }

        public function addDefenseRoll(i:int):void
        {
        }

        public function getCharacterPoints():int
        {
            return 0;
        }

        public function setCharacterPoints(value:int):void
        {
        }

        public function getAttackRolls():int
        {
            return 0;
        }

        public function getDefenseRolls():int
        {
            return 0;
        }


        public function getCharacterPointPercent():Number
        {
            return 0;
        }

        public function set onDie(value:Function):void
        {
        }

        public function get onDie():Function
        {
            return null;
        }

        public function get onAttack():Function
        {
            return null;
        }

        public function set onAttack(value:Function):void
        {
        }

        public function get onDefend():Function
        {
            return null;
        }

        public function set onDefend(value:Function):void
        {
        }


        public function get equipmentIDs():Array
        {
            return _equipmentIDs;
        }
    }
}
