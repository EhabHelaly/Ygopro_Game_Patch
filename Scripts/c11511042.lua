--Tribute for the Stars
function c11511042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511042.target)
	e1:SetOperation(c11511042.operation)
	c:RegisterEffect(e1)
end
function c11511042.filter(c,tp)
	return c:IsSetCard(0xff) and c:GetLevel()>0 and Duel.IsExistingMatchingCard(c11511042.filter2,tp,LOCATION_MZONE,0,1,c)
end
function c11511042.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xff) and c:GetLevel()>0
end
function c11511042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11511042.filter,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c11511042.filter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetLevel())
end
function c11511042.operation(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    local i=1
	for i=1,lv do
        if i>10 then k=10 else k=i end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511042,k))
        local g=Duel.SelectTarget(tp,c11511042.filter2,tp,LOCATION_MZONE,0,1,1,nil)
        local tc=g:GetFirst()
        if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
        Duel.BreakEffect()
	end
	end
end
