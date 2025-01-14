/*
    Beginning DirectX 11 Game Programming
    By Allen Sherrod and Wendy Jones

    Direct3D Text Demo - Demo used to render text to the screen using Direct3D functions.
*/


#ifndef _D3D_TEXT_DEMO_
#define _D3D_TEXT_DEMO_

#include"Dx11DemoBase.h"


class D3DTextDemo : public Dx11DemoBase
{
    public:
        D3DTextDemo( );
        virtual ~D3DTextDemo( );

        bool LoadContent( );
        void UnloadContent( );

        void Update( float dt );
        void Render( );

    private:
        bool DrawString( char* message, float startX, float startY );

    private:
        ID3D11VertexShader* solidColorVS_;
        ID3D11PixelShader* solidColorPS_;

        ID3D11InputLayout* inputLayout_;
        ID3D11Buffer* vertexBuffer_;

        ID3D11ShaderResourceView* colorMap_;
        ID3D11SamplerState* colorMapSampler_;
};

#endif