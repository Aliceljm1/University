using System;
using System.Collections.Generic;
using System.Text;

using XNA_TPS.GameBase.Cameras;
using XNA_TPS.GameBase.Lights;
using XNA_TPS.GameBase.Shapes;

namespace XNA_TPS.GameLogic.Levels
{
    public struct GameLevel
    {
        // Cameras, Lights, Terrain and Sky
        public CameraManager CameraManager;
        public LightManager LightManager;
        public Terrain Terrain;
        public SkyDome SkyDome;

        // Player and enemies
        public Player Player;
        public List<Enemy> EnemyList;
        public List<Acher> AcherList;
        //skill
        public Amor amor;
        public IceBlast fire;
        public FireBurning fireBurning;
        //BulletList
        public List<Bullet> BulletList;
        //static model
        public List<StaticModel> staticModel;

    }
}
