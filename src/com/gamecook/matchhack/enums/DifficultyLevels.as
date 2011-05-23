/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/21/11
 * Time: 12:39 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.enums
{
    public class DifficultyLevels
    {
        public static const EASY:String = "Easy";
        public static const MEDIUM:String = "Medium";
        public static const HARD:String = "Hard";

        public static function getLabel(playerLevel:int):String
        {
            switch (playerLevel)
            {
                case 1:
                    return EASY;
                    break;
                case 2:
                    return MEDIUM;
                    break;
                case 3:
                    return HARD;
                    break;
            }

            return null;
        }
    }
}
