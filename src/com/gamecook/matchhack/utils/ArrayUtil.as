/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/16/11
 * Time: 10:24 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.utils {
    public class ArrayUtil {
        public static function shuffleArray(value:Array):Array
        {
            var arr:Array = value.slice();
            var arr2:Array = [];
            while (arr.length > 0) {
                arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
            }

            return arr2;
        }
    }
}
