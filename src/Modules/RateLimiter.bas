Attribute VB_Name = "RateLimiter"
Option Explicit

' ====================================================================
' RateLimiter Module - Controle de taxa de requisi��es para APIs
' ====================================================================

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

' Fun��o para limitar taxa de requisi��es
' Use esta fun��o antes de fazer requisi��es API que precisam de limita��o de taxa
Public Sub LimitRequestRate(ByRef timestamps As Collection, ByVal maxRequestsPerSecond As Long)
    ' Limita a taxa de requisi��es por segundo
    '
    ' Args:
    '   timestamps (Collection): Cole��o com timestamps das requisi��es
    '   maxRequestsPerSecond (Long): N�mero m�ximo de requisi��es permitidas por segundo

    Const ONE_SECOND As Double = 1# / (24# * 60# * 60#) ' 1 segundo em formato de data do VB
    Dim currentTime As Date
    currentTime = Now

    ' Remove timestamps mais antigos que 1 segundo
    Do While timestamps.Count > 0
        If DateDiff("s", timestamps(1), currentTime) >= 1 Then
            timestamps.Remove 1
        Else
            Exit Do
        End If
    Loop

    ' Se atingiu o limite de requisi��es por segundo, aguarda
    If timestamps.Count >= maxRequestsPerSecond Then
        Dim sleepTime As Double
        sleepTime = ONE_SECOND - DateDiff("s", timestamps(1), currentTime) / 86400#

        ' Converte para milissegundos e dorme
        Sleep CLng(sleepTime * 86400# * 1000#)
    End If

    ' Adiciona novo timestamp
    timestamps.Add Now
End Sub

