#pragma once
#include "CSprite.h"
#include "Singleton.h"
#include "Font.h"
#include <vector>
using namespace std;

#define MAX_HP 20

class GameScore
{
protected:
	CSprite* _sprite;
	Font* _arial;
	int _simonScore;
	int _gameTimer;
	int _gameStage;
	int _weaponCount;
	int _simonHP;
	int _enemyHP;
	int _liveCount;
	int _currentWeapon;
	vector<CSprite*> _vWeaponSprite;
	CSprite* _hpSprite;
	void _initialize();
	

public:
	GameScore(void);
	GameScore(LPDIRECT3DDEVICE9 d3ddev_, int size_, int screenWidth_, int screenHeight_);
	void drawTable();
	void drawScore();
	// deltaTime is in second
	void initTimer(int deltaTime_);
	int getTimer(); // return Time left of game in second
	void SetTimer(int x);
	int GetWeaponCount();
	void SetWeaponCount(int x);
	void SetSimonScore(int x);
	// deltaTime_ is in milisecond
	void updateScore(int gameStage_,int simonScore_, int deltaTime_, int simonHP_, int liveCount_, EnumID weaponID_, int weaponCount_, int enemyHP_ = 20);
	~GameScore(void);
};

