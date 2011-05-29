/**
 * Created by IntelliJ IDEA.
 * User: jfreeman
 * Date: 3/22/11
 * Time: 3:56 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.enums
{
    public class PlayerClassTemplates
    {
        public static const KNIGHT:String = "Knight";
        public static const MAGE:String = "Mage";
        public static const THIEF:String = "Theif";
        public static const NECROMANCER:String = "Necromancer";
        public static const BARBARIAN:String = "Barbarian";
        public static const DARK_MAGE:String = "Dark Mage";

        public static function getPlayerClasses():Array
        {
            return [KNIGHT, MAGE, THIEF, NECROMANCER, BARBARIAN, DARK_MAGE];
        }

        private static const CLASS_TEMPLATES:Object = new Object();
        {
            CLASS_TEMPLATES[KNIGHT] = {life:10, attackRoll:3, defense:2, potions:5, visibility:3};
            CLASS_TEMPLATES[MAGE] = {life:5, attackRoll:2, defense:1, potions:12, visibility:3};
            CLASS_TEMPLATES[THIEF] = {life:7, attackRoll:2, defense:1, potions:10, visibility:3};
            CLASS_TEMPLATES[NECROMANCER] = {life:13, attackRoll:3, defense:2, potions:2, visibility:3};
            CLASS_TEMPLATES[BARBARIAN] = {life:10, attackRoll:5, defense:3, potions:2, visibility:3};
            CLASS_TEMPLATES[DARK_MAGE] = {life:5, attackRoll:4, defense:1, potions:10, visibility:3};
        }

        public static function getTemplate(value:String):Object
        {
            return CLASS_TEMPLATES[value];
        }
    }
}
