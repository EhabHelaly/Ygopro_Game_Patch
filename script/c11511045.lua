--Elegantea True Power
function c11511045.initial_effect(c)
	c:SetUniqueOnField(1,0,11511045)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

end
