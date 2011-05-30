/*
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 */

/**
 * Created by IntelliJ IDEA.
 * User: Jesse Freeman
 * Date: 3/8/11
 * Time: 8:57 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.maps
{
    import com.gamecook.frogue.managers.TileInstanceManager;
    import com.gamecook.frogue.maps.IMap;

    import serialize.ISerializeToObject;

    public class TCMapSelection extends AdvancedFogOfWarMapSelection implements ISerializeToObject
    {

        public function TCMapSelection(map:IMap, width:int, height:int, viewDistance:int, instanceManager:TileInstanceManager)
        {
            super(map, width, height, viewDistance, instanceManager);
        }

        public function parseObject(value:Object):void
        {
            if (value.exploredTiles)
            {
                exploredTiles = value.exploredTiles.slice();
                var total:int = exploredTiles.length;
                var i:int;
                for (i = 0; i < total; i++)
                {
                    exploredTilesHashMap[exploredTiles[i]] = " ";
                }
            }
        }

        public function toObject():Object
        {
            return {exploredTiles: exploredTiles.slice()};
        }
    }
}
