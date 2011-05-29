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
 * /
 */

package com.gamecook.matchhack.maps
{
    import com.gamecook.frogue.managers.TileInstanceManager;
    import com.gamecook.frogue.maps.FogOfWarMapSelection;
    import com.gamecook.frogue.maps.IMap;
    import com.gamecook.frogue.tiles.MonsterTile;
    import com.gamecook.frogue.tiles.TileTypes;

    public class AdvancedFogOfWarMapSelection extends FogOfWarMapSelection
    {
        protected var lightMap:Array = [];
        private var instanceManager:TileInstanceManager;

        public function AdvancedFogOfWarMapSelection(map:IMap, width:int, height:int, viewDistance:int, instanceManager:TileInstanceManager)
        {
            this.instanceManager = instanceManager;

            super(map, width, height, viewDistance);
        }


        override protected function applyLight(tiles:Array, visiblePoints:Array):void
        {
            var width:int = tiles[0].length;
            var height:int = tiles.length;

            var rows:int;
            var columns:int;

            for (rows = 0; rows < height; rows++)
            {
                for (columns = 0; columns < width; columns ++)
                {
                    var spriteID:String = TileTypes.getTileSprite("#");
                    var tileValue = tiles[rows][columns];
                    var uID:int = getTileID(columns, rows);

                    // Get base tile if it's not a wall
                    if (tileValue != "#")
                    {
                        spriteID = TileTypes.getTileSprite(" ");

                        if (tileValue != " ")
                            spriteID = spriteID.concat("," + TileTypes.getTileSprite(tiles[rows][columns]));

                    }

                    //Pre-Process tile based on type.
                    if (TileTypes.isMonster(tileValue))
                    {
                        var newMonsterTile:MonsterTile = instanceManager.getInstance(uID.toString(), tileValue) as MonsterTile
                        var newTileID:String = newMonsterTile.getSpriteID();
                        if (newTileID != "" || newTileID)
                            spriteID = spriteID.concat("," + newMonsterTile.getSpriteID());
                    }


                    //Apply lighting effects
                    if (lightMap[uID])
                    {
                        if(_fullLineOfSight)
                    {
                        id = 0;
                    }
                        else
                        {
                        var id:int = Math.round((viewDistance - lightMap[uID]) / viewDistance * 10) - 3;
                        if (id < 1)
                            id = 0;
                        }
                        spriteID = spriteID.concat(",light" + id);
                    }
                    else if (exploredTilesHashMap[uID])
                    {
                        //trace("Out Of Sight", uID, tileValue, viewDistance+1);
                        spriteID = spriteID = spriteID.concat(",light9");
                    }
                    else if (TileTypes.isMonster(tileValue))
                    {
                        //trace("Monster in Dark", uID);
                        spriteID = TileTypes.getTileSprite(":");
                    }
                    else
                    {
                        spriteID = "light10";
                    }

                    tiles[rows][columns] = spriteID;
                }

            }
            lightMap.length = 0;
            visiblePoints.length = 0;
        }

        override protected function visit(x:int, y:int, tiles:Array, distance:int):Boolean
        {
            var uID:int = getTileID(y, x);

            lightMap[uID] = distance;

            return super.visit(x, y, tiles, distance);
        }


    }
}
