#include <time.h>
#include <d3dx9.h>
#include "mario_sample.h"
#include "utils.h"

#define MARIO_IMAGE_RIGHT L"mario_right.png"
#define MARIO_IMAGE_LEFT L"mario_left.png"
#define GROUND_MIDDLE L"ground_middle.png"
#define BRICK L"brick.png"

#define MARIO_SPEED 1.4f
#define GROUND_Y 61

#define BACKGROUND_FILE L"bg.bmp"

#define ANIMATE_RATE 30
#define JUMP_VELOCITY_BOOST 3.0f
#define FALLDOWN_VELOCITY_DECREASE 0.5f

#define VIEW_PORT_Y  600


CMarioSample::CMarioSample(HINSTANCE hInstance, LPWSTR Name, int Mode, int IsFullScreen, int FrameRate):
CGame(hInstance,Name,Mode,IsFullScreen, FrameRate)
{
	mario_right = NULL;
	mario_left = NULL;

}

CMarioSample::~CMarioSample()
{
	delete mario_left;
	delete mario_right;
}

void CMarioSample::LoadResources(LPDIRECT3DDEVICE9 d3ddv)
{
	srand((unsigned)time(NULL));

	// TO-DO: not a very good place to initial sprite handler
	D3DXCreateSprite(d3ddv,&_SpriteHandler);


	//Background = CreateSurfaceFromFile(_d3ddv, BACKGROUND_FILE);

	HRESULT res = D3DXCreateSprite(_d3ddv,&_SpriteHandler);

	mario_x = 0;
	mario_y = GROUND_Y;

	mario_vx = 0;
	mario_vx_last = 1.0f;
	mario_vy = 0;

	mario_right = new CSprite(_SpriteHandler,MARIO_IMAGE_RIGHT,39,61,3,3);
	mario_left = new CSprite(_SpriteHandler,MARIO_IMAGE_LEFT,39,61,3,3);

	// One sprite only :)
	ground_middle = new CSprite(_SpriteHandler,GROUND_MIDDLE,32,32,1,1);
	brick = new CSprite(_SpriteHandler,BRICK,32,32,1,1);
}

int xc = 0;

void CMarioSample::RenderFrame(LPDIRECT3DDEVICE9 d3ddv, int t)
{
	// TO-DO: should enhance CGame to put a separate virtual method for updating game status


	// NOTES: If there is a class for mario, this should be mario->Update(t);
	// Putting mario update here is NOT a good place


	//
	// Update mario status
	//
	mario_x += mario_vx * t;
	mario_y += mario_vy * t;

	//
	// Animate mario if she is running
	//
	DWORD now = GetTickCount();
	if (now - last_time > 1000 / ANIMATE_RATE)
	{
		if (mario_vx > 0) mario_right->Next();
		if (mario_vx < 0) mario_left->Next();

		last_time = now;
	}

	//
	// Simulate fall down
	//
	if (mario_y > GROUND_Y) mario_vy -= FALLDOWN_VELOCITY_DECREASE;
	else 
	{
		mario_y = GROUND_Y;
		mario_vy = 0;
	}

	// Background
	/*d3ddv->StretchRect(
			Background,			// from 
			NULL,				// which portion?
			_BackBuffer,		// to 
			NULL,				// which portion?
			D3DTEXF_NONE);*/

	_SpriteHandler->Begin(D3DXSPRITE_ALPHABLEND);

	int vpx = mario_x - 400;
	//int vpx = xc;
	if (vpx<=0) vpx=0;
	xc += 1;


	int i=0;
	ground_middle->Render(16,16,vpx,VIEW_PORT_Y);
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;

	i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;
	ground_middle->Render(16+i,16,vpx,VIEW_PORT_Y);i+=32;

	int j=0;
	brick->Render(165+j,200,vpx,VIEW_PORT_Y);

	//
	//  Select correct sprite to render depends on which direction mario is facing
	//
	if (mario_vx > 0)			mario_right->Render(mario_x,mario_y,vpx,VIEW_PORT_Y);
	else if (mario_vx < 0)		mario_left->Render(mario_x,mario_y,vpx,VIEW_PORT_Y);
	else if (mario_vx_last < 0) mario_left->Render(mario_x,mario_y,vpx,VIEW_PORT_Y);
	else						mario_right->Render(mario_x,mario_y,vpx,VIEW_PORT_Y);


	brick->Render(100,47,vpx,VIEW_PORT_Y);

	_SpriteHandler->End();
}

void CMarioSample::ProcessInput(LPDIRECT3DDEVICE9 d3ddv, int t)
{
	if (IsKeyDown(DIK_RIGHT))
	{
		mario_vx = MARIO_SPEED;
		mario_vx_last = mario_vx;
	}	
	else 
		if (IsKeyDown(DIK_LEFT))
		{
			mario_vx = -MARIO_SPEED;
			mario_vx_last = mario_vx;
		}
		else 
		{
			mario_vx = 0;
			mario_left->Reset();
			mario_right->Reset();
		}
}

void CMarioSample::OnKeyDown(int KeyCode)
{
	switch (KeyCode)
	{
		case DIK_SPACE:
			if (mario_y <= GROUND_Y) mario_vy+=JUMP_VELOCITY_BOOST;			// start jump if is not "on-air"
			break;
	}
}


